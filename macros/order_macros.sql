{% macro convert_to_usd(amount_col, currency_col) %}
    case
        when {{ currency_col }} = 'USD'
            then round({{ amount_col }}, 2)
        else
            round({{ amount_col }} * c.usd_equivalent, 2)
    end
{% endmacro %}