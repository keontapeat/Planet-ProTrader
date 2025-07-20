-- ===================================================================
-- GOLDEX AI™ - Complete Supabase Database Schema
-- Universe-Level Trading Bot Intelligence System
-- ===================================================================

-- Enable UUID extension
CREATE EXTENSION IF NOT EXISTS "uuid-ossp";

-- ===================================================================
-- 1. BOTS TABLE - ProTrader Bot Management
-- ===================================================================

CREATE TABLE bots (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    strategy_type VARCHAR(50) NOT NULL,
    training_score DECIMAL(5,2) DEFAULT 0.00,
    win_rate DECIMAL(5,2) DEFAULT 0.00,
    avg_flip_speed DECIMAL(8,2) DEFAULT 0.00, -- in minutes
    total_trades INTEGER DEFAULT 0,
    total_profit DECIMAL(12,2) DEFAULT 0.00,
    max_drawdown DECIMAL(5,2) DEFAULT 0.00,
    confidence_level DECIMAL(5,2) DEFAULT 0.00,
    risk_level VARCHAR(20) DEFAULT 'MEDIUM',
    bot_version VARCHAR(20) DEFAULT '1.0.0',
    generation_level INTEGER DEFAULT 1,
    dna_pattern JSONB DEFAULT '{}',
    learning_data JSONB DEFAULT '{}',
    active_sessions INTEGER DEFAULT 0,
    last_trade_time TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===================================================================
-- 2. TRADES TABLE - Complete Trade History & Screenshots
-- ===================================================================

CREATE TABLE trades (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bot_id UUID REFERENCES bots(id) ON DELETE CASCADE,
    user_id UUID, -- Add user management later
    symbol VARCHAR(20) NOT NULL DEFAULT 'XAUUSD',
    entry_price DECIMAL(12,6) NOT NULL,
    exit_price DECIMAL(12,6),
    stop_loss DECIMAL(12,6),
    take_profit DECIMAL(12,6),
    lot_size DECIMAL(10,4) NOT NULL,
    profit DECIMAL(12,2) DEFAULT 0.00,
    trade_direction VARCHAR(10) NOT NULL, -- BUY/SELL
    trade_start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    trade_end_time TIMESTAMP WITH TIME ZONE,
    trade_duration_seconds INTEGER,
    screenshot_before_url TEXT,
    screenshot_during_url TEXT,
    screenshot_after_url TEXT,
    confidence_score DECIMAL(5,2) DEFAULT 0.00,
    flipped_percentage DECIMAL(8,2) DEFAULT 0.00,
    news_filter_used BOOLEAN DEFAULT FALSE,
    trade_reasoning TEXT,
    trade_grade VARCHAR(20) DEFAULT 'AVERAGE', -- ELITE, GOOD, AVERAGE, POOR
    market_session VARCHAR(20), -- SYDNEY, TOKYO, LONDON, NEWYORK
    economic_news_impact VARCHAR(20) DEFAULT 'NONE',
    execution_speed_ms INTEGER DEFAULT 0,
    slippage_points DECIMAL(6,2) DEFAULT 0.00,
    spread_points DECIMAL(6,2) DEFAULT 0.00,
    trade_status VARCHAR(20) DEFAULT 'OPEN', -- OPEN, CLOSED, CANCELLED
    metadata JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===================================================================
-- 3. LEADERBOARD TABLE - Bot Performance Rankings
-- ===================================================================

CREATE TABLE leaderboard (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bot_id UUID REFERENCES bots(id) ON DELETE CASCADE,
    rank INTEGER NOT NULL,
    score DECIMAL(10,2) NOT NULL,
    category VARCHAR(50) NOT NULL, -- DAILY, WEEKLY, MONTHLY, ALL_TIME
    period_start TIMESTAMP WITH TIME ZONE NOT NULL,
    period_end TIMESTAMP WITH TIME ZONE NOT NULL,
    total_profit DECIMAL(12,2) DEFAULT 0.00,
    win_rate DECIMAL(5,2) DEFAULT 0.00,
    total_trades INTEGER DEFAULT 0,
    avg_trade_duration_minutes INTEGER DEFAULT 0,
    risk_adjusted_return DECIMAL(8,4) DEFAULT 0.00,
    sharpe_ratio DECIMAL(8,4) DEFAULT 0.00,
    max_consecutive_wins INTEGER DEFAULT 0,
    max_consecutive_losses INTEGER DEFAULT 0,
    elite_trades_count INTEGER DEFAULT 0,
    last_updated TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(bot_id, category, period_start)
);

-- ===================================================================
-- 4. FEED_DATA TABLE - Training Content & Learning Materials
-- ===================================================================

CREATE TABLE feed_data (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID, -- Add user management later
    content_type VARCHAR(50) NOT NULL, -- PDF, SCREENSHOT, AUDIO, VIDEO, TEXT
    file_name VARCHAR(255),
    file_url TEXT,
    file_size_bytes BIGINT DEFAULT 0,
    content_title VARCHAR(255),
    content_description TEXT,
    extracted_text TEXT,
    key_concepts JSONB DEFAULT '[]',
    trading_strategies JSONB DEFAULT '[]',
    bot_assignments JSONB DEFAULT '[]', -- Which bots should learn from this
    learning_progress JSONB DEFAULT '{}',
    content_tags JSONB DEFAULT '[]',
    processed_by_ai BOOLEAN DEFAULT FALSE,
    ai_summary TEXT,
    ai_insights JSONB DEFAULT '{}',
    training_impact_score DECIMAL(5,2) DEFAULT 0.00,
    view_count INTEGER DEFAULT 0,
    last_accessed TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===================================================================
-- 5. BOT_LEARNING_SESSIONS TABLE - Training & Improvement Records
-- ===================================================================

CREATE TABLE bot_learning_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bot_id UUID REFERENCES bots(id) ON DELETE CASCADE,
    feed_data_id UUID REFERENCES feed_data(id) ON DELETE CASCADE,
    session_type VARCHAR(50) NOT NULL, -- TRAINING, ANALYSIS, REPLAY, FEEDBACK
    learning_objective VARCHAR(255),
    content_consumed JSONB DEFAULT '{}',
    insights_gained JSONB DEFAULT '{}',
    strategy_updates JSONB DEFAULT '{}',
    before_performance JSONB DEFAULT '{}',
    after_performance JSONB DEFAULT '{}',
    improvement_metrics JSONB DEFAULT '{}',
    session_duration_minutes INTEGER DEFAULT 0,
    effectiveness_score DECIMAL(5,2) DEFAULT 0.00,
    session_status VARCHAR(20) DEFAULT 'ACTIVE', -- ACTIVE, COMPLETED, FAILED
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===================================================================
-- 6. SCREENSHOT_METADATA TABLE - Enhanced Screenshot Management
-- ===================================================================

CREATE TABLE screenshot_metadata (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    trade_id UUID REFERENCES trades(id) ON DELETE CASCADE,
    screenshot_type VARCHAR(20) NOT NULL, -- BEFORE, DURING, AFTER
    file_url TEXT NOT NULL,
    file_size_bytes BIGINT DEFAULT 0,
    image_width INTEGER,
    image_height INTEGER,
    capture_timestamp TIMESTAMP WITH TIME ZONE NOT NULL,
    chart_timeframe VARCHAR(10), -- 1M, 5M, 15M, 1H, 4H, 1D
    price_at_capture DECIMAL(12,6),
    indicators_visible JSONB DEFAULT '[]',
    annotations JSONB DEFAULT '{}',
    ai_analysis JSONB DEFAULT '{}',
    quality_score DECIMAL(5,2) DEFAULT 0.00,
    storage_provider VARCHAR(20) DEFAULT 'SUPABASE',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===================================================================
-- 7. MARKET_SESSIONS TABLE - Trading Session Performance
-- ===================================================================

CREATE TABLE market_sessions (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    session_name VARCHAR(50) NOT NULL, -- SYDNEY, TOKYO, LONDON, NEWYORK
    session_date DATE NOT NULL,
    start_time TIMESTAMP WITH TIME ZONE NOT NULL,
    end_time TIMESTAMP WITH TIME ZONE NOT NULL,
    total_trades INTEGER DEFAULT 0,
    winning_trades INTEGER DEFAULT 0,
    losing_trades INTEGER DEFAULT 0,
    total_profit DECIMAL(12,2) DEFAULT 0.00,
    average_trade_duration_minutes INTEGER DEFAULT 0,
    highest_profit_trade DECIMAL(12,2) DEFAULT 0.00,
    lowest_profit_trade DECIMAL(12,2) DEFAULT 0.00,
    market_volatility DECIMAL(8,4) DEFAULT 0.00,
    news_events JSONB DEFAULT '[]',
    session_analysis JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(session_name, session_date)
);

-- ===================================================================
-- 8. BOT_PERFORMANCE_METRICS TABLE - Detailed Analytics
-- ===================================================================

CREATE TABLE bot_performance_metrics (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    bot_id UUID REFERENCES bots(id) ON DELETE CASCADE,
    metric_date DATE NOT NULL,
    trades_count INTEGER DEFAULT 0,
    win_rate DECIMAL(5,2) DEFAULT 0.00,
    profit_factor DECIMAL(8,4) DEFAULT 0.00,
    sharpe_ratio DECIMAL(8,4) DEFAULT 0.00,
    max_drawdown DECIMAL(5,2) DEFAULT 0.00,
    avg_win DECIMAL(10,2) DEFAULT 0.00,
    avg_loss DECIMAL(10,2) DEFAULT 0.00,
    largest_win DECIMAL(10,2) DEFAULT 0.00,
    largest_loss DECIMAL(10,2) DEFAULT 0.00,
    consecutive_wins INTEGER DEFAULT 0,
    consecutive_losses INTEGER DEFAULT 0,
    risk_reward_ratio DECIMAL(8,4) DEFAULT 0.00,
    execution_speed_avg_ms INTEGER DEFAULT 0,
    slippage_avg_points DECIMAL(6,2) DEFAULT 0.00,
    daily_summary JSONB DEFAULT '{}',
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    UNIQUE(bot_id, metric_date)
);

-- ===================================================================
-- 9. NOTIFICATIONS TABLE - Bot Alerts & Reminders
-- ===================================================================

CREATE TABLE notifications (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    user_id UUID,
    bot_id UUID REFERENCES bots(id) ON DELETE CASCADE,
    notification_type VARCHAR(50) NOT NULL, -- FEED_REMINDER, TRADE_ALERT, PERFORMANCE_UPDATE
    title VARCHAR(255) NOT NULL,
    message TEXT NOT NULL,
    priority VARCHAR(20) DEFAULT 'MEDIUM', -- HIGH, MEDIUM, LOW
    read_status BOOLEAN DEFAULT FALSE,
    action_required BOOLEAN DEFAULT FALSE,
    action_data JSONB DEFAULT '{}',
    scheduled_for TIMESTAMP WITH TIME ZONE,
    sent_at TIMESTAMP WITH TIME ZONE,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===================================================================
-- 10. TRADING_STRATEGIES TABLE - Bot Strategy Repository
-- ===================================================================

CREATE TABLE trading_strategies (
    id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
    name VARCHAR(100) NOT NULL,
    description TEXT,
    category VARCHAR(50) NOT NULL, -- SCALPING, SWING, BREAKOUT, TREND_FOLLOWING
    strategy_code JSONB NOT NULL,
    parameters JSONB DEFAULT '{}',
    backtesting_results JSONB DEFAULT '{}',
    risk_level VARCHAR(20) DEFAULT 'MEDIUM',
    min_confidence_required DECIMAL(5,2) DEFAULT 70.00,
    max_drawdown_limit DECIMAL(5,2) DEFAULT 10.00,
    win_rate_target DECIMAL(5,2) DEFAULT 60.00,
    profit_factor_target DECIMAL(8,4) DEFAULT 1.5,
    timeframes JSONB DEFAULT '["1H", "4H"]',
    market_conditions JSONB DEFAULT '{}',
    creator_bot_id UUID REFERENCES bots(id),
    version VARCHAR(20) DEFAULT '1.0.0',
    is_active BOOLEAN DEFAULT TRUE,
    usage_count INTEGER DEFAULT 0,
    success_rate DECIMAL(5,2) DEFAULT 0.00,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ===================================================================
-- INDEXES for Performance Optimization
-- ===================================================================

-- Trades indexes
CREATE INDEX idx_trades_bot_id ON trades(bot_id);
CREATE INDEX idx_trades_symbol ON trades(symbol);
CREATE INDEX idx_trades_start_time ON trades(trade_start_time);
CREATE INDEX idx_trades_profit ON trades(profit);
CREATE INDEX idx_trades_status ON trades(trade_status);

-- Bots indexes
CREATE INDEX idx_bots_strategy_type ON bots(strategy_type);
CREATE INDEX idx_bots_win_rate ON bots(win_rate);
CREATE INDEX idx_bots_total_profit ON bots(total_profit);
CREATE INDEX idx_bots_training_score ON bots(training_score);

-- Leaderboard indexes
CREATE INDEX idx_leaderboard_category ON leaderboard(category);
CREATE INDEX idx_leaderboard_rank ON leaderboard(rank);
CREATE INDEX idx_leaderboard_score ON leaderboard(score);
CREATE INDEX idx_leaderboard_period ON leaderboard(period_start, period_end);

-- Feed data indexes
CREATE INDEX idx_feed_data_content_type ON feed_data(content_type);
CREATE INDEX idx_feed_data_processed ON feed_data(processed_by_ai);
CREATE INDEX idx_feed_data_created ON feed_data(created_at);

-- Performance metrics indexes
CREATE INDEX idx_performance_bot_date ON bot_performance_metrics(bot_id, metric_date);
CREATE INDEX idx_performance_win_rate ON bot_performance_metrics(win_rate);

-- ===================================================================
-- FUNCTIONS for Automated Updates
-- ===================================================================

-- Function to update bot statistics
CREATE OR REPLACE FUNCTION update_bot_stats()
RETURNS TRIGGER AS $$
BEGIN
    IF TG_OP = 'INSERT' OR TG_OP = 'UPDATE' THEN
        UPDATE bots SET
            total_trades = (
                SELECT COUNT(*) FROM trades WHERE bot_id = NEW.bot_id
            ),
            win_rate = (
                SELECT COALESCE(
                    (COUNT(*) FILTER (WHERE profit > 0) * 100.0 / NULLIF(COUNT(*), 0)), 0
                ) FROM trades WHERE bot_id = NEW.bot_id
            ),
            total_profit = (
                SELECT COALESCE(SUM(profit), 0) FROM trades WHERE bot_id = NEW.bot_id
            ),
            last_trade_time = NEW.trade_start_time,
            updated_at = NOW()
        WHERE id = NEW.bot_id;
    END IF;
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

-- Trigger to auto-update bot stats
CREATE TRIGGER trigger_update_bot_stats
    AFTER INSERT OR UPDATE ON trades
    FOR EACH ROW
    EXECUTE FUNCTION update_bot_stats();

-- Function to update leaderboard
CREATE OR REPLACE FUNCTION update_leaderboard()
RETURNS void AS $$
BEGIN
    -- Update daily leaderboard
    INSERT INTO leaderboard (bot_id, rank, score, category, period_start, period_end, total_profit, win_rate, total_trades)
    SELECT 
        b.id,
        ROW_NUMBER() OVER (ORDER BY b.total_profit DESC),
        b.total_profit + (b.win_rate * 10),
        'DAILY',
        CURRENT_DATE,
        CURRENT_DATE + INTERVAL '1 day',
        b.total_profit,
        b.win_rate,
        b.total_trades
    FROM bots b
    WHERE b.total_trades > 0
    ON CONFLICT (bot_id, category, period_start) 
    DO UPDATE SET
        rank = EXCLUDED.rank,
        score = EXCLUDED.score,
        total_profit = EXCLUDED.total_profit,
        win_rate = EXCLUDED.win_rate,
        total_trades = EXCLUDED.total_trades,
        last_updated = NOW();
END;
$$ LANGUAGE plpgsql;

-- ===================================================================
-- STORED PROCEDURES for Common Operations
-- ===================================================================

-- Get bot leaderboard
CREATE OR REPLACE FUNCTION get_bot_leaderboard(
    category_filter VARCHAR(50) DEFAULT 'ALL_TIME',
    limit_count INTEGER DEFAULT 10
)
RETURNS TABLE (
    bot_id UUID,
    bot_name VARCHAR(100),
    rank INTEGER,
    score DECIMAL(10,2),
    total_profit DECIMAL(12,2),
    win_rate DECIMAL(5,2),
    total_trades INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        l.bot_id,
        b.name,
        l.rank,
        l.score,
        l.total_profit,
        l.win_rate,
        l.total_trades
    FROM leaderboard l
    JOIN bots b ON l.bot_id = b.id
    WHERE l.category = category_filter
    ORDER BY l.rank
    LIMIT limit_count;
END;
$$ LANGUAGE plpgsql;

-- Get bot performance summary
CREATE OR REPLACE FUNCTION get_bot_performance_summary(bot_uuid UUID)
RETURNS TABLE (
    total_trades INTEGER,
    win_rate DECIMAL(5,2),
    total_profit DECIMAL(12,2),
    avg_trade_duration_minutes INTEGER,
    best_trade DECIMAL(12,2),
    worst_trade DECIMAL(12,2),
    current_streak INTEGER
) AS $$
BEGIN
    RETURN QUERY
    SELECT 
        COUNT(*)::INTEGER,
        COALESCE((COUNT(*) FILTER (WHERE profit > 0) * 100.0 / NULLIF(COUNT(*), 0)), 0)::DECIMAL(5,2),
        COALESCE(SUM(profit), 0)::DECIMAL(12,2),
        COALESCE(AVG(trade_duration_seconds) / 60, 0)::INTEGER,
        COALESCE(MAX(profit), 0)::DECIMAL(12,2),
        COALESCE(MIN(profit), 0)::DECIMAL(12,2),
        0::INTEGER -- Calculate streak separately
    FROM trades 
    WHERE bot_id = bot_uuid 
    AND trade_status = 'CLOSED';
END;
$$ LANGUAGE plpgsql;

-- ===================================================================
-- VIEWS for Common Queries
-- ===================================================================

-- Elite trades view
CREATE VIEW elite_trades AS
SELECT 
    t.*,
    b.name as bot_name,
    b.strategy_type
FROM trades t
JOIN bots b ON t.bot_id = b.id
WHERE t.trade_grade = 'ELITE' 
AND t.profit > 150 
AND t.confidence_score > 85;

-- Bot performance dashboard view
CREATE VIEW bot_dashboard AS
SELECT 
    b.id,
    b.name,
    b.strategy_type,
    b.win_rate,
    b.total_profit,
    b.total_trades,
    b.training_score,
    COALESCE(l.rank, 999) as current_rank,
    CASE 
        WHEN b.last_trade_time > NOW() - INTERVAL '1 hour' THEN 'ACTIVE'
        WHEN b.last_trade_time > NOW() - INTERVAL '24 hours' THEN 'RECENT'
        ELSE 'INACTIVE'
    END as status
FROM bots b
LEFT JOIN leaderboard l ON b.id = l.bot_id AND l.category = 'DAILY'
ORDER BY b.total_profit DESC;

-- ===================================================================
-- SECURITY POLICIES (Row Level Security)
-- ===================================================================

-- Enable RLS on all tables
ALTER TABLE bots ENABLE ROW LEVEL SECURITY;
ALTER TABLE trades ENABLE ROW LEVEL SECURITY;
ALTER TABLE leaderboard ENABLE ROW LEVEL SECURITY;
ALTER TABLE feed_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE bot_learning_sessions ENABLE ROW LEVEL SECURITY;
ALTER TABLE screenshot_metadata ENABLE ROW LEVEL SECURITY;
ALTER TABLE notifications ENABLE ROW LEVEL SECURITY;

-- Basic policy for authenticated users (customize based on your auth system)
CREATE POLICY "Allow authenticated users to view bots" ON bots FOR SELECT USING (true);
CREATE POLICY "Allow authenticated users to view trades" ON trades FOR SELECT USING (true);
CREATE POLICY "Allow authenticated users to view leaderboard" ON leaderboard FOR SELECT USING (true);

-- ===================================================================
-- INITIAL DATA SEEDS
-- ===================================================================

-- Insert sample bots
INSERT INTO bots (name, strategy_type, win_rate, total_profit, training_score) VALUES
('GoldSniper-X1', 'SCALPING', 87.5, 2450.00, 92.5),
('SwiftSweep-Pro', 'BREAKOUT', 76.2, 1875.50, 88.0),
('TrendMaster-AI', 'TREND_FOLLOWING', 82.1, 3200.75, 95.0),
('PrecisionBot-V2', 'SWING', 79.8, 2100.25, 89.5),
('Lightning-Scalper', 'SCALPING', 85.0, 1950.00, 91.0);

-- Insert sample trading strategies
INSERT INTO trading_strategies (name, description, category, strategy_code, risk_level) VALUES
('ICT Power of 3', 'Institutional order flow strategy based on accumulation, manipulation, and distribution', 'TREND_FOLLOWING', '{"entry_rules": ["asia_range_sweep", "london_killzone", "ny_reversal"], "exit_rules": ["tp_at_opposing_liquidity", "sl_beyond_structure"]}', 'MEDIUM'),
('London Breakout', 'Trade the breakout of London session range', 'BREAKOUT', '{"entry_rules": ["london_range_break", "volume_confirmation"], "exit_rules": ["trailing_stop", "time_based_exit"]}', 'HIGH'),
('Fibonacci Retracement', 'Enter on deep retracements with confluence', 'SWING', '{"entry_rules": ["78.6_fib_level", "support_resistance", "candlestick_pattern"], "exit_rules": ["take_profit_levels", "break_of_structure"]}', 'LOW');

-- ===================================================================
-- FINAL NOTES
-- ===================================================================

-- This schema provides:
-- 1. Complete bot management and tracking
-- 2. Comprehensive trade history with screenshots
-- 3. Performance analytics and leaderboards
-- 4. Learning content management (Feed Me feature)
-- 5. Real-time notifications
-- 6. Strategy repository
-- 7. Market session analysis
-- 8. Automated triggers and functions
-- 9. Security policies
-- 10. Optimized indexes for performance

-- To use this schema:
-- 1. Run this SQL in your Supabase SQL editor
-- 2. Set up proper authentication policies based on your user system
-- 3. Configure storage buckets for screenshots and files
-- 4. Set up real-time subscriptions for live updates
-- 5. Create API endpoints for mobile app integration

-- For production use, consider:
-- - Implementing proper user authentication
-- - Setting up automated backups
-- - Monitoring performance metrics
-- - Implementing data archiving for old trades
-- - Adding more sophisticated security policies

-- 🚀 GOLDEX AI™ - Universe-Level Trading Intelligence System Ready! 🚀