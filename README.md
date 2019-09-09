# Use

1. Install yarn, https://yarnpkg.com/lang/en/docs/install/#centos-stable
1. Clone this repo
1. cd mig-ui-assets
1. Checkout branch you intend to work with
1. Run ./update-assets.sh

# update-assets.sh:
  - This script requires passing in zero, one, or two parameters.
  - If no parameters are passed in assets will be built from the corresponding mig-ui branch.
  - Otherwise the first should be the mig-ui branch to build mig-ui from.
  - You may also optionally pass in a specific hash to build from.
