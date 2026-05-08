-- =====================================================
-- WORKING SCHEMA - Matches Current Frontend
-- =====================================================
-- Run this in your Supabase SQL Editor

-- 1. DROP OLD TABLES
DROP TABLE IF EXISTS public.tasks CASCADE;
DROP TABLE IF EXISTS public.open_loops CASCADE;
DROP TABLE IF EXISTS public.daily_briefings CASCADE;
DROP TABLE IF EXISTS public.summaries CASCADE;
DROP TABLE IF EXISTS public.analytics CASCADE;

-- 2. CREATE TASKS TABLE (Matches Frontend)
CREATE TABLE public.tasks (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  
  -- Task details
  title TEXT NOT NULL,
  description TEXT,
  
  -- AI metadata
  ai_generated BOOLEAN DEFAULT FALSE,
  ai_source TEXT DEFAULT 'decomposer',
  ai_parent_prompt TEXT,
  ai_difficulty TEXT CHECK (ai_difficulty IN ('easy', 'medium', 'hard')),
  
  -- Priority
  priority TEXT DEFAULT 'medium' CHECK (priority IN ('low', 'medium', 'high', 'urgent')),
  ai_priority_score INTEGER DEFAULT 0,
  
  -- Status
  status TEXT DEFAULT 'todo' CHECK (status IN ('todo', 'in_progress', 'completed', 'cancelled')),
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  completed_at TIMESTAMPTZ
);

-- 3. CREATE OPEN_LOOPS TABLE (Matches Frontend)
CREATE TABLE public.open_loops (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  
  -- Loop details
  title TEXT NOT NULL,
  description TEXT,
  
  -- Source
  source_type TEXT CHECK (source_type IN ('email', 'task', 'calendar', 'drive', 'manual')),
  
  -- Status
  status TEXT DEFAULT 'open' CHECK (status IN ('open', 'in_progress', 'closed', 'dismissed')),
  
  -- AI detection
  ai_detected BOOLEAN DEFAULT FALSE,
  ai_confidence_score INTEGER CHECK (ai_confidence_score BETWEEN 0 AND 100),
  
  -- Timestamps
  created_at TIMESTAMPTZ DEFAULT NOW(),
  updated_at TIMESTAMPTZ DEFAULT NOW(),
  closed_at TIMESTAMPTZ
);

-- 4. CREATE OTHER TABLES
CREATE TABLE public.daily_briefings (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  briefing_date DATE DEFAULT CURRENT_DATE,
  content JSONB NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, briefing_date)
);

CREATE TABLE public.summaries (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  original_text TEXT NOT NULL,
  summary_text TEXT NOT NULL,
  created_at TIMESTAMPTZ DEFAULT NOW()
);

CREATE TABLE public.analytics (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  week_start DATE NOT NULL,
  tasks_completed INTEGER DEFAULT 0,
  loops_closed INTEGER DEFAULT 0,
  focus_minutes INTEGER DEFAULT 0,
  productivity_score INTEGER DEFAULT 0,
  ai_insights TEXT,
  created_at TIMESTAMPTZ DEFAULT NOW(),
  UNIQUE(user_id, week_start)
);

-- 5. ENABLE ROW LEVEL SECURITY
ALTER TABLE public.tasks ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.open_loops ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.summaries ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.daily_briefings ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.analytics ENABLE ROW LEVEL SECURITY;

-- 6. CREATE POLICIES
CREATE POLICY "Own tasks" ON public.tasks FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Own loops" ON public.open_loops FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Own summaries" ON public.summaries FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Own briefings" ON public.daily_briefings FOR ALL USING (auth.uid() = user_id);
CREATE POLICY "Own analytics" ON public.analytics FOR ALL USING (auth.uid() = user_id);

-- 7. CREATE INDEXES FOR PERFORMANCE
CREATE INDEX idx_tasks_user_id ON public.tasks(user_id);
CREATE INDEX idx_tasks_status ON public.tasks(status);
CREATE INDEX idx_tasks_priority_score ON public.tasks(ai_priority_score DESC);

CREATE INDEX idx_open_loops_user_id ON public.open_loops(user_id);
CREATE INDEX idx_open_loops_status ON public.open_loops(status);

-- 8. REFRESH CACHE
NOTIFY pgrst, 'reload schema';
