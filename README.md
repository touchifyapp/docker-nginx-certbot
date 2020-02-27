# Supported tags and respective Dockerfile links

*  [`1.17.8`, `1.17`, `1`, `latest` (Dockerfile)](https://github.com/touchifyapp/docker-nginx-certbot/blob/master/Dockerfile)

This image is updated via [pull requests to the `touchifyapp/docker-nginx-certbot` GitHub repo](https://github.com/touchifyapp/docker-nginx-certbot/pulls).

# [Nginx](https://www.nginx.com/) & [Certbot](https://certbot.eff.org/): A container that include both nginx and certbot allowing to request and renew [Let's Encrypt](https://letsencrypt.org/) certificates automatically.

<img src="https://www.nginx.com/wp-content/uploads/2019/10/NGINX-Logo-White-Endorsement-RGB.svg" alt="Nginx Logo" width="250">
&nbsp;&nbsp;&nbsp;&nbsp;
<img src="https://certbot.eff.org/images/certbot-logo-1A.svg" alt="Certbot Logo" width="250">

`Nginx` (pronounced "engine-x") is an open source reverse proxy server for HTTP, HTTPS, SMTP, POP3, and IMAP protocols, as well as a load balancer, HTTP cache, and a web server (origin server).

`Certbot` is a free, open source software tool for automatically using [Let’s Encrypt](https://letsencrypt.org/) certificates on manually-administrated websites to enable HTTPS.

## How to use

### Basic Usage

The following sample shows how to run the container to request a certificate for multiple domains.

```bash
docker run -dt \
  --name reverse-server \
  -p 80:80 \
  -p 443:443 \
  -v $(PWD)/letsencrypt:/etc/letsencrypt \
  -v $(PWD)/certbot:/usr/share/nginx/certbot \
  -e EMAIL="myemail@mycompany.com" \
  -e DOMAINS="mycompany.com www.mycompany.com" \
  touchify/nginx-certbot
```

### Configuration

 * **EMAIL:** Sets the email to use to request Let's Encrypt certificates.
 * **DOMAINS:** Sets the domain(s) to request from Let's Encrypt. For multiple domains, separated by spaces.
 * **STAGING:** Sets to `1` to use certbot in staging mode.

## License

View [license information](https://github.com/touchifyapp/docker-nginx-certbot/blob/master/LICENSE) for the software contained in this image.

## Supported Docker versions

This image is officially supported on Docker version 1.12+.

Please see [the Docker installation documentation](https://docs.docker.com/installation/) for details on how to upgrade your Docker daemon.

## User Feedback

### Documentation

Documentation for this image is stored in [the `touchifyapp/docker-nginx-certbot` GitHub repo](https://github.com/touchifyapp/docker-nginx-certbot).
Be sure to familiarize yourself with the repository's README.md file before attempting a pull request.

### Issues

If you have any problems with or questions about this image, please contact us through a [GitHub issue](https://github.com/touchifyapp/docker-nginx-certbot/issues).

### Contributing

You are invited to contribute new features, fixes, or updates, large or small; we are always thrilled to receive pull requests, and do our best to process them as fast as we can.

Before you start to code, we recommend discussing your plans through a [GitHub issue](https://github.com/touchifyapp/docker-nginx-certbot/issues), especially for more ambitious contributions. This gives other contributors a chance to point you in the right direction, give you feedback on your design, and help you find out if someone else is working on the same thing.