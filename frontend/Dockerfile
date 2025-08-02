FROM nginx:alpine
# Remove default config
RUN rm /etc/nginx/conf.d/default.conf
# Copy your static site
COPY . /usr/share/nginx/html
# Copy your custom config to conf.d (correct place)
COPY nginx.conf /etc/nginx/conf.d/default.conf

