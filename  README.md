# Rate-My-Agent Checker

## Setup and Execution Instructions

1. Install Ruby and the Selenium WebDriver gem if not already installed.
2. Download and install Firefox.
3. Clone or download this repository.
4. Navigate to the directory containing the `rate_my_agent_checker.rb` file.
5. Run the script using the following command:

## Design Choices

- The script uses Selenium WebDriver with Firefox for web automation.
- It verifies the correct functioning of Rate-My-Agent by checking homepage content, page navigation, and search functionality.

## Potential Pitfalls and Shortcomings

- The script assumes a stable internet connection and the availability of Rate-My-Agent.com.
- It uses basic error handling and may need enhancements for production-level robustness.
- Email sending functionality is not implemented in this example.

## Bonus Tasks

- The script logs errors to an `error_log.txt` file with timestamps.
- A cron job line can be added to schedule the script to run every 3 minutes.

## Cron Job Example

To schedule the script to run every 3 minutes, add the following line to your crontab:

_/3 _ \* \* \* cd /path/to/your/script && ruby rate_my_agent_checker.rb
