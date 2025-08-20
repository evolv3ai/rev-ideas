# AGENTS.md - Codex Instructions for IdeaBrowser Platform

## Project Overview
This project implements IdeaBrowser.com - an AI-powered platform for discovering, researching, and validating high-potential startup ideas. The system combines automated trend analysis with actionable business insights to deliver pre-validated business opportunities daily. Features include AI research agents, voice-driven mobile experience, and comprehensive idea analysis dashboards.

## Architecture & Technology Stack

### Core Technologies
- **Backend**: Python 3.11+ with FastAPI/Django for API endpoints
- **Frontend**: React with Next.js 14+ (TypeScript) for SSR/SSG
- **Database**: PostgreSQL for structured data, Redis for caching, Pinecone/Weaviate for vector search
- **AI/LLM**: OpenAI GPT-4 API, Claude API for analysis and chat
- **Search & Data**: Google Trends API, Reddit API, SEO APIs (Ahrefs/SEMrush)
- **Voice**: Web Speech API, Google Cloud Speech-to-Text/Text-to-Speech
- **Task Queue**: Celery with Redis for background processing
- **Containerization**: Docker with docker-compose

### Key Services
1. **API Service** - FastAPI backend for client requests
2. **Idea Analysis Engine** - Automated research and scoring system
3. **AI Research Agent** - Custom idea validation on-demand
4. **Voice Service** - Speech recognition and synthesis
5. **Trend Monitor** - Real-time trend tracking and alerts
6. **Database** - PostgreSQL + Redis + Vector DB

## Development Setup

### Prerequisites
```bash
# Required tools
- Docker & Docker Compose
- Python 3.11+
- Node.js 18+
- PostgreSQL 14+
- Redis 6+
- Pinecone/Weaviate account (for vector search)
```

### Initial Setup Commands
```bash
# Clone and setup
git clone <repo>
cd ideabrowser

# Backend setup
cd backend
python -m venv venv
source venv/bin/activate  # or venv\Scripts\activate on Windows
pip install -r requirements.txt
cp .env.example .env
# Edit .env with API keys (OpenAI, Google Trends, Reddit, etc.)

# Frontend setup
cd ../frontend
npm install
cp .env.example .env.local

# Database setup
docker-compose up -d postgres redis weaviate
python backend/manage.py migrate
python backend/manage.py seed_ideas  # Load initial idea database

# Start services
docker-compose up
```

## Project Structure
```
ideabrowser/
├── backend/
│   ├── api/              # FastAPI/Django endpoints
│   ├── analysis/         # Idea analysis engine
│   ├── agents/           # AI research agents
│   ├── trends/           # Trend monitoring
│   ├── voice/            # Voice processing
│   ├── models/           # Database models
│   └── tasks/            # Celery background tasks
├── frontend/
│   ├── components/       # React components
│   ├── pages/            # Next.js pages
│   ├── services/         # API clients
│   ├── hooks/            # Custom React hooks
│   ├── voice/            # Voice UI components
│   └── styles/           # Tailwind CSS
├── mobile/
│   ├── ios/              # iOS app (optional)
│   ├── android/          # Android app (optional)
│   └── pwa/              # Progressive Web App
├── docker/
│   └── Dockerfile        # Container definitions
├── tests/
│   ├── unit/
│   ├── integration/
│   └── e2e/
└── docker-compose.yml
```

## Core Features to Implement

### 1. Idea Discovery & Browsing
- [ ] Idea of the Day (Daily Deep Dive) system
- [ ] Full idea database with 400+ validated ideas
- [ ] Search and filtering (by type, market, audience, ARR)
- [ ] Greg's Picks curation system
- [ ] Trending ideas and hot badges
- [ ] Shortlisting and favorites functionality

### 2. Idea Analysis Dashboard
- [ ] Problem & solution narrative generation
- [ ] Key metrics and keyword demand tracking
- [ ] Multi-dimensional scoring system (1-10 ratings)
- [ ] Business model and revenue potential analysis
- [ ] Community signals aggregation (Reddit, Facebook, YouTube)
- [ ] Market gap identification
- [ ] Execution plan and roadmap generation
- [ ] Framework analyses (Value Prop, ACP, Value Ladder)

### 3. AI-Powered Tools
- [ ] AI Research Agent for custom idea validation
- [ ] AI Strategist Chat with context awareness
- [ ] Idea Builder prompt generator (Bolt.new, V0, Claude)
- [ ] Founder-fit assessment engine
- [ ] Automated trend analysis and alerts
- [ ] Data export and API access

### 4. Voice-Driven Mobile Experience
- [ ] Responsive mobile UI with PWA support
- [ ] Voice search and navigation commands
- [ ] Text-to-speech for idea narration
- [ ] Conversational voice agent
- [ ] Smart assistant integration (Siri, Google, Alexa)
- [ ] Offline caching for mobile

### 5. User Management & Monetization
- [ ] Free, Starter, and Pro subscription tiers
- [ ] Idea claiming and workspace features
- [ ] Email notifications and daily digests
- [ ] Usage tracking and quotas
- [ ] Payment integration (Stripe)

## Key Implementation Guidelines

### Idea Analysis Engine
1. Aggregate data from multiple sources (trends, communities, keywords)
2. Use AI to synthesize coherent narratives
3. Apply scoring algorithms consistently
4. Cache analysis results aggressively
5. Update scores based on new signals

### AI Agent Development
1. Implement rate limiting for external APIs
2. Use prompt engineering for quality outputs
3. Maintain conversation context in Redis
4. Handle API failures gracefully
5. Track token usage and costs

### Voice Interface
1. Support natural language commands
2. Implement voice activity detection
3. Provide visual feedback during voice interaction
4. Handle ambiguous commands with confirmation
5. Optimize for mobile performance

### Frontend Requirements
1. Server-side rendering for SEO
2. Lazy loading for idea lists
3. Real-time updates via WebSockets
4. Progressive enhancement for voice features
5. Accessibility compliance (WCAG 2.1)

### Testing Strategy
```bash
# Run all tests
make test

# Unit tests
pytest tests/unit/

# Integration tests
pytest tests/integration/

# Frontend tests
npm run test

# Voice interface tests
npm run test:voice

# E2E tests
npm run test:e2e
```

## API Endpoints (Initial)
```
GET    /api/v1/ideas                   # List all ideas (paginated)
GET    /api/v1/ideas/daily             # Get idea of the day
GET    /api/v1/ideas/{id}              # Get specific idea details
POST   /api/v1/ideas/search            # Search ideas
GET    /api/v1/ideas/{id}/analysis     # Get full analysis
POST   /api/v1/ideas/{id}/claim        # Claim an idea
POST   /api/v1/ideas/{id}/favorite     # Save to shortlist

GET    /api/v1/trends                  # Get trending topics
GET    /api/v1/trends/{id}             # Get trend details

POST   /api/v1/ai/research             # Custom idea research (Pro)
POST   /api/v1/ai/chat                 # AI strategist chat
POST   /api/v1/ai/founder-fit          # Assess founder fit
POST   /api/v1/ai/builder              # Generate builder prompts

POST   /api/v1/voice/transcribe        # Speech to text
POST   /api/v1/voice/synthesize        # Text to speech
POST   /api/v1/voice/command           # Process voice command

POST   /api/v1/auth/register           # User registration
POST   /api/v1/auth/login              # User login
GET    /api/v1/user/profile            # Get user profile
GET    /api/v1/user/shortlist          # Get saved ideas
```

## Environment Variables
```bash
# Backend (.env)
DATABASE_URL=postgresql://user:pass@localhost/ideabrowser
REDIS_URL=redis://localhost:6379
VECTOR_DB_URL=http://localhost:8080  # Weaviate
OPENAI_API_KEY=sk-...
ANTHROPIC_API_KEY=sk-ant-...
GOOGLE_TRENDS_API_KEY=...
REDDIT_CLIENT_ID=...
REDDIT_CLIENT_SECRET=...
STRIPE_SECRET_KEY=sk_...
GOOGLE_CLOUD_API_KEY=...  # For Speech APIs
SECRET_KEY=...
CELERY_BROKER_URL=redis://localhost:6379/0

# Frontend (.env.local)
NEXT_PUBLIC_API_URL=http://localhost:8000
NEXT_PUBLIC_STRIPE_KEY=pk_...
NEXT_PUBLIC_GOOGLE_ANALYTICS=G-...
```

## Build and Deployment
```bash
# Development
make dev

# Production build
make build

# Run with Docker
docker-compose -f docker-compose.prod.yml up

# Deploy to cloud
make deploy

# Run voice tests
make test-voice
```

## Code Style and Standards
- Python: Black formatter, flake8, mypy type hints
- TypeScript: ESLint + Prettier, strict mode
- React: Functional components with hooks
- API: OpenAPI/Swagger documentation
- Voice: W3C Web Speech API standards
- Commit messages: Conventional Commits
- 85% test coverage minimum

## Performance Requirements
- Page load time <2 seconds
- Voice recognition latency <500ms
- AI chat response <3 seconds
- Idea analysis generation <30 seconds
- Support 1000+ concurrent users
- 99.9% uptime SLA

## Security Considerations
- JWT authentication with refresh tokens
- Rate limiting on all endpoints
- Input sanitization for voice commands
- Secure API key management
- GDPR compliance for user data
- Content moderation for user-generated ideas

## Voice Interface Specifications
- Support 10+ core voice commands
- 95% accuracy for common commands
- Fallback to text input on recognition failure
- Multi-language support (initially English)
- Wake word detection (optional)
- Noise cancellation preprocessing

## Monitoring and Analytics
- User engagement metrics (DAU, MAU)
- Idea interaction tracking
- Voice command usage analytics
- API performance monitoring
- Error tracking with Sentry
- Custom events for business metrics

## Documentation
- API documentation with OpenAPI/Swagger
- Voice command reference guide
- Component library with Storybook
- User guides and tutorials
- Developer onboarding docs

## Getting Help
- Check `/docs` for detailed documentation
- Run `make help` for available commands
- Review tests for implementation examples
- Check GitHub issues for known problems

## Next Steps for Codex
1. Review the ideabrowser.prd.md file for complete requirements
2. Set up the basic project structure as outlined
3. Implement the idea database and analysis engine
4. Build the frontend with Next.js and React
5. Integrate AI agents for research and chat
6. Implement voice interface with Web Speech API
7. Create the mobile-responsive UI
8. Add authentication and subscription management
9. Build the trend monitoring system
10. Deploy and test the complete platform

Start by creating the project structure and implementing the idea database with basic CRUD operations.
