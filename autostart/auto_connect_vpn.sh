# Connect to primary network
PRIMARY_CONN=$(nmcli -t -f NAME,AUTOCONNECT connection show | grep -v "lo" | grep ":yes" | head -n 1 | cut -d: -f1)

if [ -n "$PRIMARY_CONN" ]; then
    nmcli connection up "$PRIMARY_CONN" 2>/dev/null
    
    # Wait for connection (max 10s)
    for i in {1..10}; do
        if nmcli -t -f NAME,STATE connection show --active | grep -q "^${PRIMARY_CONN}:activated$"; then
            echo "Connected to $PRIMARY_CONN (${i}s)"
            break
        fi
        sleep 1
    done
    
    # Connect to VPN if configured
    SECONDARY_UUID=$(nmcli -t -f connection.secondaries connection show "$PRIMARY_CONN" | cut -d: -f2)
    
    if [ -n "$SECONDARY_UUID" ]; then
        sleep 2
        nmcli connection up uuid "$SECONDARY_UUID"
        
        # Wait for VPN (max 10s)
        for i in {1..10}; do
            nmcli connection show --active | grep -q "$SECONDARY_UUID" && break
            sleep 1
        done
    fi
fi
