FROM node:20-alpine

WORKDIR /app

# Install dependencies for building and healthcheck
RUN apk add --no-cache git python3 make g++ wget curl

# Install pnpm globally (Strudel uses pnpm as package manager)
RUN npm install -g pnpm

# Clone Strudel repository from Codeberg
RUN git clone --depth 1 https://codeberg.org/uzu/strudel.git /app/strudel

# Set working directory
WORKDIR /app/strudel

# Install dependencies using pnpm
RUN pnpm install

# Build the application
RUN pnpm run build || echo "Build step skipped if not needed"

# Fix the dev script in website/package.json to use correct --host flag
# Astro v5 needs just --host (boolean), not --host 0.0.0.0
RUN if [ -f website/package.json ]; then \
        echo "Fixing website/package.json dev script"; \
        sed -i 's/"dev": "astro dev --host 0\.0\.0\.0 --host"/"dev": "astro dev --host"/g' website/package.json || \
        sed -i 's/--host 0\.0\.0\.0 --host/--host/g' website/package.json || \
        echo "Could not modify package.json, will use as-is"; \
        echo "Updated dev script:"; \
        grep '"dev"' website/package.json || true; \
    fi

# Expose the port (Astro default is 4321)
EXPOSE 4321

# Set environment variables for Astro
ENV HOST=0.0.0.0
ENV PORT=4321

# Start the development server from root (it handles the website subdirectory)
WORKDIR /app/strudel
CMD ["pnpm", "run", "dev"]

