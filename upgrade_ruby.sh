#!/bin/bash

echo "Ruby 3.2.2 Upgrade Script"
echo "======================="

# Check current Ruby version
echo "Current Ruby version:"
ruby -v

# Install Ruby 3.2.2 if using rbenv
if command -v rbenv &> /dev/null; then
    echo "Installing Ruby 3.2.2 with rbenv..."
    rbenv install 3.2.2
    rbenv local 3.2.2
fi

# Install Ruby 3.2.2 if using rvm
if command -v rvm &> /dev/null; then
    echo "Installing Ruby 3.2.2 with rvm..."
    rvm install 3.2.2
    rvm use 3.2.2
fi

# Update bundler
echo "Updating bundler..."
gem install bundler

# Remove old Gemfile.lock
echo "Removing old Gemfile.lock..."
rm -f Gemfile.lock

# Install gems
echo "Installing gems..."
bundle install

echo "Ruby upgrade complete!"
echo "New Ruby version:"
ruby -v