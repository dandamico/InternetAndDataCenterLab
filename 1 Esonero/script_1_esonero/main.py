# This is a sample Python script.

# Press Shift+F10 to execute it or replace it with your code.
# Press Double Shift to search everywhere for classes, files, tool windows, actions, and settings.
from zapv2 import ZAPv2
import time
from pprint import pprint


def print_hi(name):
    # Use a breakpoint in the code line below to debug your script.
    print(f'Hi, {name}')  # Press Ctrl+F8 to toggle the breakpoint.


# Press the green button in the gutter to run the script.


def active_scan(target):
    # scan = spider_scan(target)
    scanId = zap.spider.scan(target)
    while int(zap.spider.status(scanId)) < 100:
        # Poll the status until it completes
        print('Spider progress %: {}'.format(zap.spider.status(scanId)))
        time.sleep(1)
    print('Spider has completed!')

    print('Active Scanning target {}'.format(target))
    scanID = zap.ascan.scan(target)
    while int(zap.ascan.status(scanID)) < 100:
        # Loop until the scanner has finished
        print('Scan progress %: {}'.format(zap.ascan.status(scanID)))
        time.sleep(5)

    print('Active Scan completed')
    # Print vulnerabilities found by the scanning
    print('Hosts: {}'.format(', '.join(zap.core.hosts)))
    print('Alerts: ')
    pprint(zap.core.alerts(baseurl=target))
    print(zap.core.alerts(baseurl=target))
    
    print("Tipo zap.core.alerts: {}".format(type(zap.core.alerts())))
    st = 0
    pg = 5000
    alert_dict = {}
    alert_count = 0
    alerts = zap.alert.alerts(baseurl=target, start=st, count=pg)
    blacklist = [1, 2]
    while len(alerts) > 0:
        print('Reading ' + str(pg) + ' alerts from ' + str(st))
        alert_count += len(alerts)
        for alert in alerts:
            plugin_id = alert.get('pluginId')
            #alert_dict.pop(alert)
            if plugin_id in blacklist:
                continue
            if alert.get('risk') == 'High':
                # Trigger any relevant postprocessing
                continue
            if alert.get('risk') == 'Informational':
                # Ignore all info alerts - some of them may have been downgraded by security annotations
                continue
        st += pg
        alerts = zap.alert.alerts(start=st, count=pg)
    print('Total number of alerts: ' + str(alert_count))
    print(alert_dict)
    res = alerts
    return res


def spider_scan(target):
    print('Spidering target {}'.format(target))
    # The scan returns a scan id to support concurrent scanning
    scanId = zap.spider.scan(target)
    while int(zap.spider.status(scanId)) < 100:
        # Poll the status until it completes
        print('Spider progress %: {}'.format(zap.spider.status(scanId)))
        time.sleep(1)
    print('Spider has completed!')
    # res = dict(zap.spider.results(scanID))
    print(zap.spider.full_results(scanId))
    # for res in zap.spider.full_results(scanId):
    #     print(res)
    res = zap.spider.full_results(scanId)
    return res


if __name__ == '__main__':
    localProxy = {"http": "http://192.168.10.80:8081"}

    zap = ZAPv2(proxies=localProxy, apikey="rgrm3mstvqtk5gmfgiftsens5o")
    active_scan("http://192.168.10.40:8080")
