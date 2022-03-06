# Install loopback DKMS module.
sudo apt install -y v4l2loopback-dkms

# Add virtual loopback interface for OBS.
sudo modprobe v4l2loopback exclusive_caps=1 card_label='OBS Virtual Camera'