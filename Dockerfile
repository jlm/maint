FROM rails:onbuild
ENV RAILS_ENV=production
CMD ["sh", "/usr/src/app/init.sh"]
