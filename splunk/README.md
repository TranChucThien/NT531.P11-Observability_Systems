## Setup Splunk Enterprise on Ubuntu

1. Download Splunk package
```
wget -O splunk-9.3.1-0b8d769cb912-Linux-x86_64.tgz "https://download.splunk.com/products/splunk/releases/9.3.1/linux/splunk-9.3.1-0b8d769cb912-Linux-x86_64.tgz"
```

2. Extract Splunk to /opt/
```
sudo tar xvzf splunk-9.3.1-0b8d769cb912-Linux-x86_64.tgz -C /opt
```

3. Set $SPLUNK_HOME
```
export SPLUNK_HOME=/opt/splunk
```

4. Ensure all files and directories are owned by current user (Replace ubuntu with username)
```
sudo chown -RP ubuntu /opt/splunk
```

5. Start Splunk up for the first time, this will generate initial config files (Replace ubuntu with username)
```
/opt/splunk/bin/splunk start --accept-license -user ubuntu
```

6. If Splunk server fails to start, run this command
```
/opt/splunk/bin/splunk start --accept-license
```

## Configure Splunk as Vector's Sink
1. Access http://public-splunk-server-ip:8000
2. Go to Settings > Data > Data inputs
3. Go to HTTP Event Collector > Add New
4. 