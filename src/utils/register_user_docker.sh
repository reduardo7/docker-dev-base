@e "Adding $(@style bold)$USER$(@style normal) to docker group..."
sudo usermod -aG docker $USER
@e "$(@style bold)Remember that you will have to log out and back in for this to take effect!"
