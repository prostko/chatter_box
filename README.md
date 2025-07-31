# Chatter Box

A modern Rails 7.2 application built with Vue.js, Vite, and PostgreSQL. This application features real-time chat functionality with Redis for Action Cable and a modern frontend built with Vue 3, Pinia, and Tailwind CSS.

## Ruby version

This application requires Ruby 3.3.4. You can check your Ruby version with:

```bash
ruby --version
```

If you need to install or switch Ruby versions, we recommend using a version manager like [rbenv](https://github.com/rbenv/rbenv) or [rvm](https://rvm.io/).

## Node.js version

This application requires Node.js 22.17.1. You can check your Node.js version with:

```bash
node --version
```

## System dependencies

### Required software

- **Ruby 3.3.4** - The main programming language
- **Node.js 22.17.1** - For frontend build tools and dependencies
- **PostgreSQL** - Database server
- **Redis** - For Action Cable and caching
- **Git** - Version control

### Installing system dependencies

#### macOS (using Homebrew)
```bash
# Install Homebrew if you haven't already
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"

# Install dependencies
brew install ruby@3.3 postgresql redis node

# Add Ruby to your PATH (add to ~/.zshrc or ~/.bash_profile)
export PATH="/opt/homebrew/opt/ruby@3.3/bin:$PATH"
```

#### Ubuntu/Debian
```bash
# Install system packages
sudo apt-get update
sudo apt-get install -y ruby-full postgresql postgresql-contrib redis-server nodejs npm

# Install Node.js 22.x
curl -fsSL https://deb.nodesource.com/setup_22.x | sudo -E bash -
sudo apt-get install -y nodejs
```

#### Windows
- Install [RubyInstaller](https://rubyinstaller.org/) for Ruby 3.3.4
- Install [PostgreSQL](https://www.postgresql.org/download/windows/)
- Install [Redis for Windows](https://github.com/microsoftarchive/redis/releases)
- Install [Node.js](https://nodejs.org/) 22.17.1

## Configuration

### Environment variables

Create a `.env` file in the root directory with the following variables:

```bash
# Database
DATABASE_URL=postgresql://localhost/chatter_box_development

# Redis
REDIS_URL=redis://localhost:6379

# Rails
RAILS_ENV=development
SECRET_KEY_BASE=your_secret_key_here

# Optional: For production
CHATTER_BOX_DATABASE_PASSWORD=your_database_password
```

### Database configuration

The application is configured to use PostgreSQL. The database configuration is in `config/database.yml`. Make sure PostgreSQL is running and accessible.

## Database creation

```bash
# Create the database
bin/rails db:create

# Run migrations
bin/rails db:migrate
```

## Database initialization

```bash
# Set up the database (creates, migrates, and seeds)
bin/rails db:prepare

# Or run each step individually:
bin/rails db:create
bin/rails db:migrate
bin/rails db:seed
```

## How to run the test suite

This application uses RSpec for testing. To run the test suite:

```bash
# Run all tests
bundle exec rspec

# Run tests with coverage
COVERAGE=true bundle exec rspec

# Run specific test files
bundle exec rspec spec/controllers/
bundle exec rspec spec/models/

# Run tests in parallel (if configured)
bundle exec parallel_rspec spec/
```

### Test database setup

```bash
# Create test database
bin/rails db:create RAILS_ENV=test

# Run migrations for test environment
bin/rails db:migrate RAILS_ENV=test
```

## Services (job queues, cache servers, search engines, etc.)

### Development

The application uses several services in development:

- **PostgreSQL** - Primary database
- **Redis** - Action Cable and caching
- **Vite** - Frontend build tool and development server

To start all services in development:

```bash
# Using Procfile.dev (recommended)
bin/dev

# Or start services individually:
redis-server &
bin/vite dev &
bin/rails server
```

### Production

In production, the application runs on Fly.io with the following services:

- **PostgreSQL** - Managed database
- **Redis** - Managed Redis instance
- **Rails server** - Application server
- **Vite** - Asset compilation

## Development setup

### Quick start

1. **Clone the repository**
   ```bash
   git clone <repository-url>
   cd chatter_box
   ```

2. **Install dependencies**
   ```bash
   # Install Ruby gems
   bundle install

   # Install Node.js dependencies
   npm install
   ```

3. **Set up the database**
   ```bash
   bin/rails db:prepare
   ```

4. **Start the development server**
   ```bash
   bin/dev
   ```

5. **Visit the application**
   Open your browser and navigate to `http://localhost:3000`

### Manual setup

If you prefer to set up each component manually:

```bash
# Install Ruby gems
bundle install

# Install Node.js dependencies
npm install

# Create and set up the database
bin/rails db:prepare

# Start Redis (in a separate terminal)
redis-server

# Start Vite development server (in a separate terminal)
bin/vite dev

# Start Rails server (in a separate terminal)
bin/rails server
```

## Deployment instructions

### Deploying to Fly.io

This application is configured for deployment to Fly.io:

1. **Install Fly CLI**
   ```bash
   curl -L https://fly.io/install.sh | sh
   ```

2. **Login to Fly**
   ```bash
   fly auth login
   ```

3. **Deploy the application**
   ```bash
   fly deploy
   ```

4. **Set up the database**
   ```bash
   fly postgres create
   fly postgres attach <your-database-name>
   ```

5. **Set up Redis**
   ```bash
   fly redis create
   fly redis attach <your-redis-name>
   ```

6. **Set environment variables**
   ```bash
   fly secrets set RAILS_MASTER_KEY=$(cat config/master.key)
   ```

### Docker deployment

The application includes a Dockerfile for containerized deployment:

```bash
# Build the Docker image
docker build -t chatter-box .

# Run the container
docker run -d -p 3000:3000 \
  -e RAILS_MASTER_KEY=your_master_key \
  -e DATABASE_URL=your_database_url \
  -e REDIS_URL=your_redis_url \
  chatter-box
```

### Environment variables for production

Set these environment variables in your production environment:

- `RAILS_MASTER_KEY` - Rails master key for credentials
- `DATABASE_URL` - PostgreSQL connection URL
- `REDIS_URL` - Redis connection URL
- `RAILS_ENV=production`
- `RAILS_SERVE_STATIC_FILES=true`

## Additional information

### Code quality

The application includes several tools for maintaining code quality:

```bash
# Run RuboCop (Ruby linting)
bundle exec rubocop

# Run ESLint (JavaScript linting)
npm run lint

# Format code with Prettier
npm run format
```

### Database management

```bash
# Reset database
bin/rails db:reset

# Drop and recreate database
bin/rails db:drop db:create db:migrate db:seed

# View database schema
bin/rails db:schema:dump
```

### Asset compilation

```bash
# Precompile assets for production
bin/rails assets:precompile

# Clean precompiled assets
bin/rails assets:clean
```

### Rails console

```bash
# Start Rails console
bin/rails console

# Start Rails console in test environment
bin/rails console --environment=test
```

## Troubleshooting

### Common issues

1. **Port already in use**
   ```bash
   # Kill processes on port 3000
   lsof -ti:3000 | xargs kill -9
   ```

2. **Database connection issues**
   - Ensure PostgreSQL is running
   - Check your database configuration in `config/database.yml`
   - Verify your `.env` file has the correct `DATABASE_URL`

3. **Redis connection issues**
   - Ensure Redis is running: `redis-server`
   - Check your `.env` file has the correct `REDIS_URL`

4. **Node.js version issues**
   - Use `nvm` to switch Node.js versions: `nvm use 22.17.1`

### Getting help

- Check the Rails logs: `tail -f log/development.log`
- Check the Vite logs in the terminal where you ran `bin/vite dev`
- Use Rails console for debugging: `bin/rails console`
