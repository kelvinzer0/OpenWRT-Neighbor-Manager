# OpenWRT Neighbor Manager

A simple tool to manage static IPv6 neighbors on OpenWrt via a LuCI GUI.

---

## Install

Run the following command on your OpenWrt router:

```bash
wget https://raw.githubusercontent.com/kelvinzer0/OpenWRT-Neighbor-Manager/refs/heads/main/src/install.sh -O - | sh
```

This script will:

* Create static neighbor configuration
* Create an init script to load neighbors at startup
* Install a LuCI module for web configuration
* Enable and start the `neighbor_manager` service

---

## Start / Stop / Restart

* **Start neighbor\_manager:**

```bash
/etc/init.d/neighbor_manager start
```

* **Stop neighbor\_manager:**

```bash
/etc/init.d/neighbor_manager stop
```

* **Restart neighbor\_manager:**

```bash
/etc/init.d/neighbor_manager restart
```

---

## Preview Screenshot

![Neighbor Manager LuCI](https://raw.githubusercontent.com/kelvinzer0/OpenWRT-Neighbor-Manager/main/assets/images/screenshot.png)

> LuCI module interface to manage static IPv6 neighbors.



