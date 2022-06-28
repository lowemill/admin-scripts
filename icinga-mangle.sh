#!/usr/bin/env bash
set -euf -o pipefail

while read LINE; do
        IP="$(echo "$LINE" | cut -f 1)"
        NAME="$(echo "$LINE" | cut -f 7)"
        CLASS="$(echo "$LINE" | cut -f 8)"
        MAC="$(echo "$LINE" | cut -f 6)"
        TYPE="Unknown"
        VENDOR="Unknown"

        if (echo "$CLASS" | grep -q 'Router'); then TYPE="Router"; fi
        if (echo "$CLASS $NAME" | grep -q "Switch"); then TYPE="Switch"; fi

        if (echo "$CLASS" | grep -qE '(UBNT|Ubiquiti)'); then VENDOR="Ubiquiti"; fi
        if (echo "$CLASS" | grep -q "D-Link"); then VENDOR="D-Link"; fi

        if (echo "$MAC" | grep -q 'ec:22:80'); then TYPE="AP"; VENDOR="D-Link"; fi
        if (echo "$NAME $CLASS" | grep -q 'UAP'); then TYPE="AP"; VENDOR="Ubiquiti"; fi
        if (echo "$NAME" | grep -qE '^vh'); then VENDOR="VMware"; TYPE="Server"; fi
        if (echo "$NAME" | grep -qE 'mac$'); then VENDOR="Linux"; TYPE="Server"; fi
        if (echo "$NAME $CLASS" | grep -qE '(Amcrest|DVR)'); then VENDOR="Amcrest"; TYPE="Appliance"; fi
        if (echo "$CLASS" | grep -q 'DGS'); then TYPE="Switch"; VENDOR="D-Link"; fi
        if (echo "$NAME $CLASS" | grep -q -E 'Cloud[ -]Key'); then TYPE="Appliance"; fi
        if (echo "$NAME $CLASS" | grep -qE '(hEX|CRS)'); then TYPE="Switch"; VENDOR="MikroTik"; fi
        if (echo "$NAME $CLASS" | grep -qE '(OmniTIK|SXT)'); then TYPE="Fixed Wireless"; VENDOR="MikroTik"; fi
        if (echo "$NAME" | grep -q 'ERP'); then TYPE="Router"; VENDOR="Ubiquiti"; fi
        if (echo "$NAME" | grep -q 'Data'); then TYPE="Appliance"; VENDOR="Seagate"; fi

        echo "$IP ($NAME) - $VENDOR $TYPE"
done
