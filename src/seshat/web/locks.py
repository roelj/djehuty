"""This module provides thread- and process locks for sensitive procedures."""

from enum import Enum
from threading import Lock
from seshat.web.config import config

try:
    import uwsgi
except ModuleNotFoundError:
    pass

class LockTypes(Enum):
    """Enumeration of lock types."""
    FILE_LIST     = 1
    PRIVATE_LINKS = 2
    SUBMIT_DATASET = 4
    OCI_REGISTRY  = 5

class LockAcquisitionTimeout(Exception):
    """Raised when a lock could not be acquired within the timeout."""

class _Held:
    """This class implements a context manager returned by Locks.locked()."""

    def __init__ (self, locks_instance, lock_type):
        self.locks     = locks_instance
        self.lock_type = lock_type

    def __enter__ (self):
        self.locks.lock (self.lock_type)
        return self

    def __exit__ (self, exc_type, exc_value, traceback):
        self.locks.unlock (self.lock_type)

class Locks:
    """This class implements multiple locks"""

    ## Only ever allow one instance of this class to exist,
    ## so that we prevent re-initializing locks.
    _instance = None
    def __new__ (cls):
        if cls._instance is None:
            cls._instance = super().__new__(cls)
        return cls._instance

    def __init__ (self):
        if getattr(self, "_initialized", False):
            return
        self.locks = { lock_type: Lock() for lock_type in LockTypes }
        self._initialized = True

    def lock (self, lock_type):
        """Lock critical section LOCK_TYPE."""
        if config.using_uwsgi:
            uwsgi.lock (lock_type.value)
            return
        if not self.locks[lock_type].acquire (blocking=True, timeout=30):
            raise LockAcquisitionTimeout (f"Could not acquire {lock_type.name}.")

    def unlock (self, lock_type):
        """Unlock critical section LOCK_TYPE."""
        if config.using_uwsgi:
            uwsgi.unlock(lock_type.value)
        else:
            self.locks[lock_type].release()

    def locked (self, lock_type):
        """Context manager for LOCK_TYPE."""
        return _Held (self, lock_type)
