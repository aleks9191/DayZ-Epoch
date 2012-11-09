private["_activatingPlayer","_trader_id","_category","_action","_id","_type","_loc","_name","_qty","_cost","_qty","_sell","_cur","_order","_tid","_currency","_actionFile","_in","_out","_part","_cat","_cancel","_Display","_File","_textCurrency","_textPart"];

{player removeAction _x} forEach s_player_parts;s_player_parts = [];

// [ _trader_id, _category, _action ];
_activatingPlayer = _this select 1;

_trader_id = (_this select 3) select 0;
_category = (_this select 3) select 1;

diag_log format["DEBUG TRADER OBJ: %1", _trader];

dayzTraderMenu = [_activatingPlayer,_trader_id,_category,_action];
publicVariable "dayzTraderMenu";
if (isServer) then {
	dayzTraderMenu call server_traders;
};

waitUntil {!isNil "dayzTraderMenuResult"};

//diag_log format["DEBUG Sell: %1", dayzTraderMenuResult];
{
	_id = parseNumber (_x select 0);
	_type = _x select 1;
	_loc = _x select 2;
	_name = _x select 3;
	_qty = parseNumber (_x select 4);
	_cost = parseNumber (_x select 5);
	_sell = parseNumber (_x select 6);
	_cur = _x select 7;
	_cat = _x select 8;
	_order = parseNumber (_x select 9);
	_tid = parseNumber (_x select 10);
	_currency = _x select 11;
	_actionFile = _x select 12;
	
	_textPart =	getText(configFile >> _type >> _name >> "displayName");
	
	_File = "\z\addons\dayz_code\actions\" + _actionFile + ".sqf";

	_part_out = _cur;
	_part_in = _name;
	_out = _sell;
	_in = 1;
	
	_textCurrency =	getText(configFile >> "CfgMagazines" >> _part_out >> "displayName");
	
	_Display = "Sell " +  _textPart + " for " + str(_sell) + " " + _textCurrency;
	
	// trade_items.sqf | [part_out, part_in, qty_out, qty_in,];
	_part = player addAction [_Display, _File,[_part_out,_part_in,_out,_in], _order, true, true, "",""];
	//diag_log format["DEBUG TRADER: %1", _part];
	s_player_parts set [count s_player_parts,_part];
	
} forEach dayzTraderMenuResult;

_cancel = player addAction ["Cancel", "\z\addons\dayz_code\actions\trade_cancel.sqf",["medical"], 99, true, false, "",""];
s_player_parts set [count s_player_parts,_cancel];

dayzTraderMenuResult = nil;
s_player_parts_crtl = 1;