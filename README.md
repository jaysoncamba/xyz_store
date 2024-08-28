# XYZ Store

Welcome to the XYZ Store project! This guide will help you set up and run the project on an Ubuntu system.

## Prerequisites

Before you begin, ensure you have the following installed on your system:

- **Ubuntu** (or a compatible Linux distribution)
- **git** (for cloning the project repository)

## Setup Instructions

Follow these steps to set up and run the XYZ Store project:

### 1. Install rbenv

`rbenv` is a tool that helps you manage Ruby versions. To install it, run the following commands:

```bash
# Update package list
sudo apt update

# Install dependencies
sudo apt install -y curl git

# Clone rbenv repository
git clone https://github.com/rbenv/rbenv.git ~/.rbenv

# Add rbenv to PATH
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc

# Initialize rbenv
echo 'eval "$(rbenv init -)"' >> ~/.bashrc

# Apply changes
source ~/.bashrc

# Install rbenv
rbenv doctor
```

### 2. Install Ruby 3.2.0

With rbenv set up, you can now install Ruby:

```bash
# Install ruby-build plugin for rbenv
git clone https://github.com/rbenv/ruby-build.git ~/.rbenv/plugins/ruby-build

# Install Ruby 3.2.0
rbenv install 3.2.0

# Set Ruby 3.2.0 as the default version
rbenv global 3.2.0

# Verify the installation
ruby -v
```

### 3. Install Bundler and Rails 7

With rbenv set up, you can now install Ruby:
```bash
gem install bundler
gem install rails -v 7.1.3.4
```

### 4 Setup the Project
```bash
git clone https://github.com/jaysoncamba/xyz_store.git
cd xyz_store
bundle install
rails db:reset
```