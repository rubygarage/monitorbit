# Monitorbit
Gem provides quick way to set up monitoring system for state of your application and node on which it's running.

Features:
  - monitoring puma(loading, threads capacity, etc.), sidekiq(successful / failed jobs, etc.), application state(slowest endpoints, 4xx/5xx errors count, etc.)
  - monitoring node state (CPU,- RAM-, SWAP-, Disk usage)
  - warning notifications with captured chart images via slack channel
  - version controlled configurations for all ecosystem

Monitorbit contains:
  - Yabeda gems, exporting puma, sidekiq and rails metrics
  - Middleware, exporting 4xx / 5xx errors' metrics
  - Docker-compose configuration for running grafana, prometheus and node_exporter
  - Prometheus and Grafana settings
  - Preconfigured dashboards

Right after running application with all ecosystem, you have 4 dashboards out of the box:
  - Rails:
    - Puma overload (Puma loading percentage)
    - Puma Metrics (Counters of max-, running- and capacity threads)
    - Throughput (Number of requests per minute)
    - Rails average response time (Total, db and view)
    - Rails throughput per endpoint (Number of requests per minute, grouped by endpoint)
    - Rails 95% response time by endpoint (Maximum response time for 95% of requests, grouped by endpoint)
    - Total jobs processed (Number of successful / failure jobs processed per second)
    - Sidekiq queues (Number of enqueued jobs, grouped by quque)
    - Job processing time 95 percentile (Maximux duration of 95% jobs)
    - Job processing time 95% by job type (Maximux duration of 95% jobs, grouped by job type)
    - Sidekiq jobs pushed by queue (Number of pushed jobs per minute, grouped by queue)
    - Sidekiq jobs Retry Set by queue (Maximum number of job retries, grouped by quque)
    - Sedekiq jobs processed by queue (Number of processed jobs per second, grouped by queue)
    - Sidekiq jobs processed by job type (Number of processed jobs per second, grouped by job type)
- Client(4xx) / Server(5xx) errors:
  - Client errors (4xx) (Number of 4xx errors, grouped by request method, path, status)
  - Server errors (5xx) (Number of 5xx errors, grouped by request method, path, status)
- Node:
  - CPU Busy (CPU loading percentage, grouped by core)
  - Used RAM Memory (RAM memory usage percentage)
  - Disk space usage (Disk space usage percentage)
  - Used SWAP (SWAP usage percentage)
- Slowest queries:
  - Slowest queries (SQL queries, sorted by average execution time)

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'monitorbit'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install monitorbit


    $ rails g monitorbit:install

    $ cp docker_compose_config/.grafana /$app_root
    $ cp docker_compose_config/.prometheus /$app_root

Add grafana, prometheus and node_exporter services, specified in our docker_compose_config/docker-compose.yml to your docker-compose.yml

## Grafana settings:
### Notifiers:
You need to create application in slack account. It will give you ability to receive text notifications. If you waant to receive captured chart images, you need to create slack bot
settings file location - .grafana/provisioning/notifiers/all.yml

keys to tweak:
  - settings.url - webhook_url
  - keys for capturing chart images:
    - uploadImage: true
    - token: your_slack_bot_token

### Datasources:
settings file location - .grafana/provisioning/datasources/all.yml

keys to tweak:
  - url - check for matching specified host and port with yours, configured within docker-compose.yml

### Dashboards:
settings file location - .grafana/provisioning/dashboards/all.yml

keys to tweak:
  - path - check for matching value of that key with configured withing docker-compose.yml

## Prometheus settings:
All, you need is to check job names and ports. They have to correspond those, specified within docker-compose.yml
settings file location - .prometheus/config.yml

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

## Code of Conduct

Everyone interacting in the Monitorbit project’s codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/monitorbit/blob/master/CODE_OF_CONDUCT.md).
