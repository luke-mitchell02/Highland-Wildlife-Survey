import pytest

from datetime import datetime
from app.components.validation import (
    normalise_date,
    normalise_time,
    normalise_number,
    normalise_weather,
    normalise_boolean,
)


class TestNormaliseDate:
    def test_valid_date(self):
        assert normalise_date("2025-03-15") == datetime(2025, 3, 15)

    def test_invalid_day(self):
        assert normalise_date("2025-03-32") is None

    def test_invalid_month(self):
        assert normalise_date("2025-13-01") is None

    def test_wrong_format_slashes(self):
        assert normalise_date("15/03/2025") is None

    def test_wrong_format_no_separator(self):
        assert normalise_date("20250315") is None

    def test_text_input(self):
        assert normalise_date("not-a-date") is None

    def test_empty_string(self):
        assert normalise_date("") is None


class TestNormaliseTime:
    def test_valid_time(self):
        assert normalise_time("14:30") == datetime(1900, 1, 1, 14, 30)

    def test_midnight(self):
        assert normalise_time("00:00") == datetime(1900, 1, 1, 0, 0)

    def test_end_of_day(self):
        assert normalise_time("23:59") == datetime(1900, 1, 1, 23, 59)

    def test_invalid_hour(self):
        assert normalise_time("25:00") is None

    def test_invalid_minute(self):
        assert normalise_time("12:60") is None

    def test_wrong_format(self):
        assert normalise_time("2:30pm") is None

    def test_empty_string(self):
        assert normalise_time("") is None


class TestNormaliseNumber:
    def test_valid_positive(self):
        assert normalise_number("5") == 5

    def test_zero_positive_only(self):
        assert normalise_number("0") is None

    def test_zero_not_positive_only(self):
        assert normalise_number("0", positive_only=False) == 0

    def test_negative_positive_only(self):
        assert normalise_number("-1") is None

    def test_negative_not_positive_only(self):
        assert normalise_number("-1", positive_only=False) == -1

    def test_non_numeric(self):
        assert normalise_number("abc") is None

    def test_float_string(self):
        assert normalise_number("3.5") is None

    def test_large_number(self):
        assert normalise_number("9999") == 9999


class TestNormaliseWeather:
    def test_valid_lowercase(self):
        assert normalise_weather("sunny") == "Sunny"

    def test_valid_uppercase(self):
        assert normalise_weather("CLOUDY") == "Cloudy"

    def test_multi_word_condition(self):
        assert normalise_weather("light rain") == "Light Rain"

    def test_invalid_condition(self):
        assert normalise_weather("tornado") is None

    def test_empty_string(self):
        assert normalise_weather("") is None


class TestNormaliseBoolean:
    @pytest.mark.parametrize("value", ["y", "yes", "t", "true", "1"])
    def test_truth_values(self, value):
        assert normalise_boolean(value) is True

    @pytest.mark.parametrize("value", ["n", "no", "f", "false", "0"])
    def test_false_values(self, value):
        assert normalise_boolean(value) is False

    def test_uppercase_truth(self):
        assert normalise_boolean("YES") is True

    def test_uppercase_false(self):
        assert normalise_boolean("NO") is False

    def test_invalid_value(self):
        assert normalise_boolean("maybe") is None

    def test_empty_string(self):
        assert normalise_boolean("") is None
