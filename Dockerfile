FROM rails:onbuild
ENV RAILS_ENV=docker
CMD ["sh", "/usr/src/app/init.sh"]
