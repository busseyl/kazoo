%%%-------------------------------------------------------------------
%%% @copyright (C) 2015, 2600Hz, INC
%%% @doc
%%%
%%% @end
%%% @contributors
%%%-------------------------------------------------------------------
-module(kzd_service_plan).

-export([account_id/1, account_id/2
         ,overrides/1, overrides/2
         ,merge_overrides/2
         ,item_activation_charge/3, item_activation_charge/4
         ,category_activation_charge/2, category_activation_charge/3

         ,categories/1, category/2
         ,items/2, item/3
        ]).

-include("kz_documents.hrl").

-type doc() :: wh_json:object().
-type api_doc() :: api_object().
-export_type([doc/0
              ,api_doc/0
             ]).

-define(PLAN, <<"plan">>).
-define(ACTIVATION_CHARGE, <<"activation_charge">>).
-define(ALL, <<"_all">>).

-spec account_id(doc()) -> api_binary().
-spec account_id(doc(), Default) -> ne_binary() | Default.
account_id(Plan) ->
    account_id(Plan, 'undefined').
account_id(Plan, Default) ->
    wh_json:get_value(<<"account_id">>, Plan, Default).

-spec overrides(doc()) -> wh_json:object().
-spec overrides(doc(), Default) -> wh_json:object() | Default.
overrides(Plan) ->
    overrides(Plan, wh_json:new()).
overrides(Plan, Default) ->
    wh_json:get_json_value(<<"overrides">>, Plan, Default).

-spec merge_overrides(doc(), wh_json:object()) -> doc().
merge_overrides(Plan, Overrides) ->
    wh_json:merge_recursive(Plan, wh_json:from_list([{?PLAN, Overrides}])).

-spec item_activation_charge(doc(), ne_binary(), ne_binary()) -> api_float().
-spec item_activation_charge(doc(), ne_binary(), ne_binary(), Default) -> float() | Default.
item_activation_charge(Plan, Category, Item) ->
    item_activation_charge(Plan, Category, Item, 'undefined').
item_activation_charge(Plan, Category, Item, Default) ->
    wh_json:get_float_value([?PLAN, Category, Item, ?ACTIVATION_CHARGE]
                            ,Plan
                            ,Default
                           ).

-spec category_activation_charge(doc(), ne_binary()) -> float().
-spec category_activation_charge(doc(), ne_binary(), Default) -> float() | Default.
category_activation_charge(Plan, Category) ->
    category_activation_charge(Plan, Category, 0.0).
category_activation_charge(Plan, Category, Default) ->
    item_activation_charge(Plan, Category, ?ALL, Default).

-spec categories(doc()) -> ne_binaries().
categories(Plan) ->
    wh_json:get_keys(?PLAN, Plan).

-spec category(doc(), ne_binary()) -> api_object().
category(Plan, CategoryId) ->
    wh_json:get_json_value([?PLAN, CategoryId], Plan).

-spec items(doc(), ne_binary()) -> ne_binaries().
items(Plan, Category) ->
    wh_json:get_keys([?PLAN, Category], Plan).

-spec item(doc(), ne_binary(), ne_binary()) -> api_object().
item(Plan, CategoryId, ItemId) ->
    wh_json:get_json_value([?PLAN, CategoryId, ItemId], Plan).
