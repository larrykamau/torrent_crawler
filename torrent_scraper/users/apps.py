from django.apps import AppConfig
from django.utils.translation import gettext_lazy as _


class UsersConfig(AppConfig):
    name = "torrent_scraper.users"
    verbose_name = _("Users")

    def ready(self):
        try:
            import torrent_scraper.users.signals  # noqa F401
        except ImportError:
            pass
