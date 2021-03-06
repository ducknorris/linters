require "resque/failure/multiple"
require "resque/failure/redis"
require "resque-sentry"

Resque::Failure::Sentry.logger = "resque"

Resque::Failure::Multiple.classes = [
  Resque::Failure::Redis,
  Resque::Failure::Sentry,
]

Resque::Failure.backend = Resque::Failure::Multiple
