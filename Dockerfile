FROM rails:onbuild
ENV RAILS_ENV=docker3
CMD ["sh", "/usr/src/app/init.sh"]
