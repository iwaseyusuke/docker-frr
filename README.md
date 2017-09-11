# docker-frr

The Docker image for [FRRouting](https://frrouting.org/)

## Run

With `docker run` command:

```bash
$ docker run -it --rm --privileged iwaseyusuke/frr
```

With `docker-compose` command:

```bash
$ wget https://github.com/iwaseyusuke/docker-frr/raw/master/docker-compose.yml

$ docker-compose run --rm frr
```

## Configuration on container

Enable specific daemons you want to start:

```
root@xxxxxxxxxxxx:~# vi /etc/frr/daemons
...(snip)...
zebra=yes
bgpd=yes
ospfd=yes
...(snip)...
```

Start FRRouting with `service` command:

```
root@xxxxxxxxxxxx:~# service frr start
```

Open `vtysh`:

```
root@xxxxxxxxxxxx:~# vtysh
```

## Magic environment value `FRR_DAEMONS`

You can specify FRRouting daemons to be started by using environment value
`FRR_DAEMONS`.

```
$ vi docker-compose.yml
...(snip)...
  environment:
    FRR_DAEMONS: zebra bgpd ospfd
...(snip)...
```
