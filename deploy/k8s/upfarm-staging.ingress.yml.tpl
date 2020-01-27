apiVersion: extensions/v1beta1
kind: Ingress
metadata:
  name: torrentscraper-staging
  namespace: staging
  labels:
    app: torrentscraper-staging
  annotations:
    kubernetes.io/ingress.class: "nginx"
    nginx.ingress.kubernetes.io/affinity: "cookie"
    nginx.ingress.kubernetes.io/session-cookie-name: "route"
    nginx.ingress.kubernetes.io/session-cookie-hash: "sha1"
    nginx.ingress.kubernetes.io/proxy-read-timeout: 86400
    nginx.ingress.kubernetes.io/proxy-send-timeout: 86400
    nginx.ingress.kubernetes.io/limit-connections: 6
    nginx.ingress.kubernetes.io/limit-rps: 6
    nginx.ingress.kubernetes.io/limit-rate: 6
spec:
  tls:
    - secretName: torrentscraper-tls-secrets
  rules:
  - host: {{ HOST_WEB }}
    http:
      paths:
      - path: /
        backend:
          serviceName: torrentscraper-frontend
          servicePort: http
  - host: {{ HOST_API }}
    http:
      paths:
      - path: /
        backend:
          serviceName: torrentscraper-backend
          servicePort: http
