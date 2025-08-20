# IdeaBrowser Platform - Codex Setup

This repository is configured for development with OpenAI Codex. It includes the IdeaBrowser PRD and is ready for Codex to build the implementation.

## Quick Start for Codex

1. **Read the core documents:**
   - `AGENTS.md` - Your primary instructions and project structure
   - `ideabrowser.prd.md` - Complete product requirements document

2. **Start development:**
   ```bash
   # Use the prepared Docker environment
   docker-compose -f docker-compose.ideabrowser.yml up
   
   # Or use the Makefile
   make setup
   make seed    # Load initial ideas
   make dev
   ```

3. **Key files to review:**
   - `Dockerfile` - Based on codex-universal for consistent environment
   - `docker-compose.ideabrowser.yml` - All services configured including Weaviate
   - `Makefile` - Common commands for development

## Project Structure Expected

```
rev-ideas/
├── AGENTS.md                     # Codex instructions (START HERE)
├── ideabrowser.prd.md            # Full PRD specification
├── Dockerfile                    # Codex-universal based
├── docker-compose.ideabrowser.yml # Service orchestration
├── Makefile                      # Development commands
├── backend/                      # TO BE CREATED BY CODEX
│   ├── api/                      # FastAPI/Django endpoints
│   ├── analysis/                 # Idea analysis engine
│   ├── agents/                   # AI research agents
│   ├── trends/                   # Trend monitoring
│   ├── voice/                    # Voice processing
│   └── requirements.txt          # Python dependencies
├── frontend/                     # TO BE CREATED BY CODEX
│   ├── components/               # React components
│   ├── pages/                    # Next.js pages
│   ├── voice/                    # Voice UI components
│   └── package.json              # Node dependencies
├── mobile/                       # TO BE CREATED BY CODEX
│   └── pwa/                      # Progressive Web App
└── tests/                        # TO BE CREATED BY CODEX
```

## Implementation Priority

1. **Phase 1: Core Backend**
   - Set up FastAPI with basic endpoints
   - Create database models (PostgreSQL + Weaviate)
   - Implement idea database and CRUD operations

2. **Phase 2: Idea Analysis**
   - Build analysis engine with scoring system
   - Integrate trend data APIs
   - Implement community signals aggregation

3. **Phase 3: Frontend**
   - Create Next.js application with SSR
   - Build idea browsing interface
   - Implement idea detail pages
   - Add search and filtering

4. **Phase 4: AI Integration**
   - AI Research Agent for custom ideas
   - AI Strategist Chat interface
   - Founder-fit assessment
   - Idea Builder prompt generation

5. **Phase 5: Voice Interface**
   - Web Speech API integration
   - Voice command processing
   - Text-to-speech for idea narration
   - Mobile PWA optimization

## Key Features to Build

### Idea Discovery
- Daily idea email system
- 400+ validated ideas database
- Search, filter, and sorting
- Greg's Picks curation
- Trending ideas

### Analysis Dashboard
- Problem/solution narratives
- Multi-dimensional scoring (1-10)
- Market metrics and keywords
- Community signals (Reddit, FB, YouTube)
- Execution plans and frameworks

### AI Capabilities
- Custom idea validation on-demand
- Contextual AI chat strategist
- Builder prompts for Bolt.new, V0, etc.
- Automated trend monitoring

### Voice Experience
- Voice search and navigation
- Idea narration (TTS)
- Conversational agent
- Mobile-first responsive design

## Environment Setup

Create `.env` file in root:
```bash
# Required API Keys
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_TRENDS_API_KEY=...
REDDIT_CLIENT_ID=...
REDDIT_CLIENT_SECRET=...
GOOGLE_CLOUD_API_KEY=...  # For Speech APIs
STRIPE_SECRET_KEY=sk_...

# Database
DATABASE_URL=postgresql://ideabrowser:ideabrowser_secret@localhost:5432/ideabrowser
REDIS_URL=redis://localhost:6379
VECTOR_DB_URL=http://localhost:8080

# Application
SECRET_KEY=your-secret-key-here
DEBUG=true
```

## Testing the Setup

```bash
# Verify Docker setup
docker-compose -f docker-compose.ideabrowser.yml ps

# Test database connection
docker-compose -f docker-compose.ideabrowser.yml exec backend python -c "import psycopg2; print('DB OK')"

# Test Weaviate vector DB
curl http://localhost:8080/v1/schema

# Run initial tests
make test

# Test voice interface
make voice-test
```

## Special Considerations

### Voice Interface
- Use Web Speech API for browser support
- Implement fallbacks for unsupported browsers
- Design for mobile-first experience
- Test with various accents/speeds

### Idea Analysis
- Cache analysis results aggressively
- Use vector search for similar ideas
- Implement incremental scoring updates
- Track data source freshness

### Subscription Management
- Free tier: 1 idea per day
- Starter: Full database access
- Pro: AI agents and advanced features
- Handle quota limits gracefully

## Notes for Codex

- The PRD emphasizes voice and mobile experience
- Start with web app, mobile apps are optional
- Focus on data quality for idea analysis
- Voice commands should feel natural
- Performance is critical for mobile users

## Getting Started Command

```bash
# This single command should set everything up
make quick-start
```

## API-First Development

Start by implementing these core endpoints:
1. `/api/v1/ideas/daily` - Idea of the day
2. `/api/v1/ideas` - List all ideas
3. `/api/v1/ideas/{id}` - Get idea details
4. `/api/v1/trends` - Trending topics
5. `/api/v1/voice/command` - Process voice

Ready for Codex to begin implementation!
