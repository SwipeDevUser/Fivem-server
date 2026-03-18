# FiveM Development Monorepo

A comprehensive monorepo containing multiple FiveM server projects and related applications.

## 📁 Project Structure

```
fivem-monorepo/
├── apps/
│   ├── fivem-dashboard/        # FiveM Admin Dashboard
│   ├── fivem-server/           # FiveM Server Backend
│   └── test-dashboard/         # Test Dashboard Application
├── packages/
│   ├── gta-rp-enterprise/      # GTA RP Enterprise Edition
│   ├── gta-rp-platform/        # GTA RP Platform Edition
│   └── txdata/                 # Transaction Data Package
└── package.json                # Root monorepo configuration
```

## 🚀 Getting Started

### Prerequisites
- Node.js 18+
- npm 9+
- Git

### Installation

```bash
# Clone the repository
git clone git@github.com:SwipeDev-User/Fivem-server.git
cd fivem-monorepo

# Install dependencies for all workspaces
npm install
```

### Development

```bash
# Start development servers for all apps
npm run dev

# Build all packages
npm run build

# Run linting
npm run lint

# Run tests
npm run test
```

## 📚 Workspaces

### Apps
Applications and user-facing services:

- **fivem-dashboard**: Next.js-based admin dashboard for server management
- **fivem-server**: Main FiveM server backend
- **test-dashboard**: Testing and staging dashboard

### Packages
Shared libraries and data packages:

- **gta-rp-enterprise**: Enterprise GTA RP implementation
- **gta-rp-platform**: Platform GTA RP implementation
- **txdata**: Transaction and data management

## 🛠️ Development Workflow

### Working with Specific Workspaces

```bash
# Install dependencies in a specific workspace
npm install --workspace=apps/fivem-dashboard

# Run a script in a specific workspace
npm run dev --workspace=apps/fivem-dashboard

# Build a specific workspace
npm run build --workspace=packages/gta-rp-enterprise
```

### Adding Dependencies

```bash
# Add a dependency to a workspace
npm install package-name --workspace=apps/fivem-dashboard

# Add a dev dependency
npm install --save-dev package-name --workspace=apps/fivem-server
```

## 📖 Documentation

- [Architecture](./ARCHITECTURE.md)
- [API Documentation](./API_DOCUMENTATION.md)
- [Deployment Guide](./DEPLOYMENT.md)
- [FiveM Server Setup](./FIVEM_SERVER_SETUP.md)

## 🔧 Configuration

- **Node.js**: 18+
- **npm**: 9+
- **Package Manager**: npm workspaces

## 📝 License

MIT

## 👥 Contributing

1. Create a feature branch
2. Make your changes
3. Commit with descriptive messages
4. Push and create a pull request

## 📞 Support

For issues and questions, please create an issue in the repository.

---

**Repository**: [github.com/SwipeDev-User/Fivem-server](https://github.com/SwipeDev-User/Fivem-server)
