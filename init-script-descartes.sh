curl -sSL https://raw.githubusercontent.com/IA-Generative/onyxia/main/init-script-marcus.sh | bash

#  FOr the python app
sudo apt-get update
sudo apt-get install libgl1-mesa-glx

#  For the frontend
# installs nvm (Node Version Manager)
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion
nvm install 20


