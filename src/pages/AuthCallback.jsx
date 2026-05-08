import React, { useEffect, useState } from 'react'
import { useNavigate } from 'react-router-dom'
import { supabase } from '../lib/supabaseClient'

export default function AuthCallback() {
  const navigate = useNavigate()
  const [status, setStatus] = useState('Signing you in...')

  useEffect(() => {
    // provider_refresh_token is ONLY available in the onAuthStateChange SIGNED_IN event.
    // getSession() does NOT return it. This is a known Supabase limitation.
    const { data: { subscription } } = supabase.auth.onAuthStateChange(async (event, session) => {
      if (event === 'SIGNED_IN' && session) {
        const providerToken = session.provider_token
        const providerRefreshToken = session.provider_refresh_token

        console.log('OAuth event:', event)
        console.log('provider_token present:', !!providerToken)
        console.log('provider_refresh_token present:', !!providerRefreshToken)

        if (providerToken) {
          setStatus('Saving Google permissions...')
          const { error: upsertError } = await supabase.from('profiles').upsert({
            id: session.user.id,
            google_access_token: providerToken,
            google_refresh_token: providerRefreshToken ?? null,
            google_token_expiry: new Date(Date.now() + 3600 * 1000).toISOString(),
          }, { onConflict: 'id' })

          if (upsertError) {
            console.error('Failed to save tokens:', upsertError)
            setStatus('Warning: Could not save Google tokens. Features may be limited.')
          } else {
            console.log('Google tokens saved successfully!')
          }
        } else {
          console.warn('No provider_token in session — Google scopes may not have been granted.')
        }

        setStatus('Redirecting...')
        subscription.unsubscribe()
        navigate('/dashboard')
      } else if (event === 'SIGNED_OUT') {
        navigate('/login')
      }
    })

    // Fallback: if onAuthStateChange never fires (e.g. page refresh mid-flow), 
    // check existing session and redirect
    supabase.auth.getSession().then(({ data: { session } }) => {
      if (!session) {
        // No session yet — wait for onAuthStateChange
        setTimeout(() => {
          supabase.auth.getSession().then(({ data: { session: s } }) => {
            if (!s) navigate('/login')
          })
        }, 3000)
      }
    })

    return () => subscription.unsubscribe()
  }, [navigate])

  return (
    <div style={{
      minHeight: '100vh',
      display: 'flex',
      alignItems: 'center',
      justifyContent: 'center',
      backgroundColor: 'var(--background)',
      flexDirection: 'column',
      gap: '16px',
    }}>
      <div style={{
        width: '60px',
        height: '60px',
        border: '4px solid var(--on-background)',
        borderTop: '4px solid var(--primary)',
        borderRadius: '50%',
        animation: 'spin 0.8s linear infinite',
      }} />
      <p style={{ fontFamily: 'var(--font-display)', fontWeight: 700, fontSize: '20px', textTransform: 'uppercase' }}>
        {status}
      </p>
      <style>{`@keyframes spin { from { transform: rotate(0deg); } to { transform: rotate(360deg); } }`}</style>
    </div>
  )
}
