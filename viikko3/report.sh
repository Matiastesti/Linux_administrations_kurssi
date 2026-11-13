#!/usr/bin/env bash

GENERATED_AT="$(date -u '+%Y-%m-%d %H:%M:%S UTC (+0000)')"
UPTIME_TEXT="$(uptime -p)"
DISK_USAGE="$(df -P / | awk 'NR == 2 {print $5}')"
DISK_NUM="${DISK_USAGE%\%}"

MEM_TOTAL="$(free -m | awk 'NR == 2 {print $2}')"
MEM_AVAILABLE="$(free -m | awk 'NR == 2 {print $7}')"
GITHUB_URL="https://github.com/Matiastesti/Linux_administrations_kurssi"

check_disk_status() {
    if [ "$DISK_NUM" -ge 80 ]; then
        echo "WARNING"
    else
        echo "OK"
    fi
}

DISK_STATUS="$(check_disk_status)"

TEMP_FILE="/var/www/html/viikko3/index.html.tmp"
FINAL_FILE="/var/www/html/viikko3/index.html"

cat > "$TEMP_FILE" <<EOF
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Week 3 – Server Status Report</title>
    <style>
        body {
            font-family: system-ui, -apple-system, sans-serif;
            max-width: 900px;
            margin: 40px auto;
            padding: 0 20px;
            line-height: 1.6;
            background: #090d16;
            color: #e2e8f0;
        }
        header {
            text-align: center;
            margin-bottom: 30px;
        }
        h1 {
            color: #38bdf8;
            font-size: 2.5rem;
            margin-bottom: 5px;
            text-shadow: 0 0 20px rgba(56, 189, 248, 0.3);
        }
        header p {
            color: #94a3b8;
        }
        h2 {
            color: #38bdf8;
            border-bottom: 2px solid #1e293b;
            padding-bottom: 8px;
            margin-top: 0;
        }
        section {
            margin: 24px 0;
            padding: 24px;
            background: #111827;
            border: 1px solid #1f2937;
            border-radius: 16px;
            box-shadow: 0 10px 25px -5px rgba(0, 0, 0, 0.5);
        }
        .table-container {
            overflow-x: auto;
        }
        table {
            border-collapse: collapse;
            width: 100%;
            margin-top: 10px;
        }
        th, td {
            border: 1px solid #374151;
            padding: 12px;
            text-align: left;
        }
        th {
            background: #1f2937;
            color: #f3f4f6;
        }
        tr:nth-child(even) {
            background: rgba(31, 41, 55, 0.3);
        }
        code {
            background: #1f2937;
            color: #38bdf8;
            padding: 3px 6px;
            border-radius: 6px;
            border: 1px solid #374151;
            font-family: monospace;
        }
        a {
            color: #38bdf8;
            text-decoration: none;
        }
        a:hover {
            text-decoration: underline;
        }
        .note {
            color: #94a3b8;
            font-size: 0.95rem;
        }
        .status-ok {
            color: #4ade80;
            font-weight: bold;
        }
        .status-warn {
            color: #f87171;
            font-weight: bold;
        }
        footer {
            text-align: center;
            margin-top: 40px;
            color: #64748b;
        }
    </style>
</head>
<body>
    <header>
        <h1>Server Status Report</h1>
        <p>Week 3: Linux command line and Bash scripting</p>
        <p class="note">Simple server status page running on my Ubuntu VM in cPouta.</p>
    </header>
    
    <section>
        <h2>Current Server Status</h2>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th scope="col">Information</th>
                        <th scope="col">Value</th>
                    </tr>
                </thead>
                <tbody>
                    <tr>
                        <th scope="row">Report generated</th>
                        <td><code>$GENERATED_AT</code></td>
                    </tr>
                    <tr>
                        <th scope="row">Server uptime</th>
                        <td>$UPTIME_TEXT</td>
                    </tr>
                    <tr>
                        <th scope="row">Root filesystem disk usage</th>
                        <td>$DISK_USAGE</td>
                    </tr>
                    <tr>
                        <th scope="row">Disk space status</th>
                        <td><span class="status-ok">$DISK_STATUS</span> (OK under 80%, WARNING at 80% or over)</td>
                    </tr>
                    <tr>
                        <th scope="row">Total RAM</th>
                        <td>$MEM_TOTAL MiB</td>
                    </tr>
                    <tr>
                        <th scope="row">Available RAM</th>
                        <td>$MEM_AVAILABLE MiB</td>
                    </tr>
                </tbody>
            </table>
        </div>
        <p class="note" style="margin-top: 15px;">
            The script updates this page every minute. Reload after a minute or two to see the new time.
        </p>
    </section>

    <section>
        <h2>Commands Used</h2>
        <ul>
            <li><code>date -u '+%Y-%m-%d %H:%M:%S UTC (+0000)'</code>: shows the current time and date in UTC.</li>
            <li><code>uptime -p</code>: shows how long the server has been up.</li>
            <li><code>df -P / | awk 'NR == 2 {print \$5}'</code>: gets the disk usage percentage from the second row.</li>
            <li><code>free -m</code>: shows total and available RAM in MiB.</li>
        </ul>
    </section>

    <section>
        <h2>How the Script Works</h2>
        <p>The script runs basic Linux commands and saves the outputs into variables. Then the <code>check_disk_status</code> function uses an if-statement to check if disk usage is 80% or higher.</p>
        <p>It writes the HTML to a temp file (<code>index.html.tmp</code>) first and then moves it to <code>index.html</code> so Nginx always shows a complete page.</p>
    </section>

    <section>
        <h2>Scheduling</h2>
        <p>I used <strong>cron</strong> (<code>crontab -e</code>) with <code>* * * * * /bin/bash /opt/viikko3/report.sh</code> so the script runs every minute. Cron starts automatically when the VM boots up, so it keeps working after a reboot.</p>
    </section>

    <section>
        <h2>Test Results</h2>
        <h3>Syntax Check & Manual Run</h3>
        <p>I checked the script with <code>bash -n report.sh</code> and got no errors. Running <code>./report.sh</code> manually updated the page right away.</p>
        
        <h3>Disk Space Status Tests</h3>
        <p>I tested the if-statement by temporarily putting in 50%, 80%, and 90% as test values, and then changed it back to the real disk command:</p>
        <div class="table-container">
            <table>
                <thead>
                    <tr>
                        <th>Test Input</th>
                        <th>Expected Status</th>
                        <th>Actual Status</th>
                    </tr>
                </thead>
                <tbody>
                    <tr><td>50%</td><td>OK</td><td><span class="status-ok">OK</span></td></tr>
                    <tr><td>80%</td><td>WARNING</td><td><span class="status-warn">WARNING</span></td></tr>
                    <tr><td>90%</td><td>WARNING</td><td><span class="status-warn">WARNING</span></td></tr>
                </tbody>
            </table>
        </div>

        <h3>Automatic Updates & Reboot Test</h3>
        <p>I waited a couple of minutes and refreshed the browser to verify that the timestamp updated automatically every minute. I also rebooted the server with <code>sudo reboot</code> and checked that both the Week 2 app and this Week 3 page came back online and kept updating.</p>
    </section>

    <section>
        <h2> What problems i solved and what did i learn?</h2>
        <p>At first I connected to an old server IP by mistake, so none of my changes showed up on the real page. Checking the right IP address and folder paths fixed it. Also learned that writing to a temp file before moving it to <code>index.html</code> avoids broken pages during updates.</p>
    </section>

    <footer>
        <p><a href="$GITHUB_URL">View source code on GitHub</a></p>
    </footer>
</body>
</html>
EOF

mv "$TEMP_FILE" "$FINAL_FILE"
