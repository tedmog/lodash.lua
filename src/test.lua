local _ = require 'lodash'

local function test_invoke()
	assert(_.str(_.invoke({'1.first', '2.second', '3.third'}, string.sub, 1, 1))
	 == '{"1", "2", "3"}')
end

local function test_map()
	assert(_.str(_.map({1, 2, 3, 4, 5, 6, 7, 8, 9}, function(n)
	    return n * n
	end)) == '{1, 4, 9, 16, 25, 36, 49, 64, 81}')
end

local function test_partition()
	local t = _.partition({1, 2, 3, 4, 5, 6, 7}, function(n)
    	return n  > 3
    end)
	assert(_.str(t) == '{{4, 5, 6, 7}, {1, 2, 3}}')
end

local function test_pluck()
	local users = {
	  { user = 'barney', age = 36, child = {age = 5}},
	  { user = 'fred',   age = 40, child = {age = 6} }
	}
	assert(_.str(_.pluck(users, {'user'})) == '{"barney", "fred"}')
	assert(_.str(_.pluck(users, {'child', 'age'}) == '{5, 6}'))
end

local function test_reduce()
	assert(_.reduce({1, 2, 3}, function(total, n)
	 	return n + total;
	end) == 6)
	local s = _.str(_.reduce({a = 1, b = 2}, function(result, n, key) 
		result[key] = n * 3
		return result;
	end, {}))
	assert(s == '{["a"]=3, ["b"]=6}' or s == '{["b"]=6, ["a"]=3}')
end

local function test_reduceRight()
	local array = {0, 1, 2, 3, 4, 5};
	assert(_.reduceRight(array, function(str, other) 
	  return str .. other
	end, '') == '543210')

end
local function test_reject()
	local t = _.reject({1, 2, 3, 4, '5', 6, '7'}, _.isNumber)
	assert(_.str(t) == '{"5", "7"}')
end

local function test_sample()
	local t = _.sample({1, 2, 3, 4, '5', 6, '7'}, 2)
	assert(#t == 2)
	local t = _.sample({1, 2, 3, 4, '5', 6, '7'}, 3)
	assert(#t == 3)
	local t = _.sample({1, 2, 3, 4, '5', 6, '7'}, 4)
	assert(#t == 4)
end

local function test_sample()
	assert(_.size({'abc', 'def'}) == 2)
	assert(_.size('abcdefg') == 7)
	assert(_.size({a=1, b=2,c=3}) == 3)
end

local function test_some()
	assert(_.some({1, 2, 3, 4, '5', 6}, _.isString) == true)
	assert(_.some({1, 2, 3, 4, 5, 6}, _.isString) == false)
end

local function test_sortBy()
	assert(_.str(_.sortBy({1, 2, 3}, function (a)
		return math.sin(a)
	end)) == '{1, 3, 2}')

	local users = {
		{ user='fred' },
		{ user='alex' },
		{ user='zoee' },
		{ user='john' },
	}
	assert(_.str(_.sortBy(users, function (a)
		return a.user..0
	end)) == '{{["user"]="alex"}, {["user"]="fred"}, {["user"]="john"}, {["user"]="zoee"}}')
end

local function test_After()
	local trueAfter3Call = _.after(3, function() return true end)
	assert(trueAfter3Call() == nil)
	assert(trueAfter3Call() == nil)
	assert(trueAfter3Call() == nil)
	assert(trueAfter3Call() == true)
end

local function test_Ary()
	local sum = function(...)
		local t = _.table(...)
		local s = 0
		for i, v in ipairs(t) do
			s = s + v
		end
		return s;
	end

	local sumOnly3 =_.ary(sum, 3)
	assert(sumOnly3(1, 2, 3, 4, 5) == 6)
end

local function test_Before()
	local trueBefore3Call = _.before(3, function(a) return a end)
	assert(trueBefore3Call(1) == 1)
	assert(trueBefore3Call(2) == 2)
	assert(trueBefore3Call(3) == 3)
	assert(trueBefore3Call(4) == 3) -- Should return the last result
end

local function test_modArgs()
	local increment = function(...)
	 	return _.args(_.map(_.table(...), function(n)
	    	return n + 1
		end))
	end

	local pow = function(...)
		return _.args(_.map(_.table(...), function(n)
	    	return n * n
		end))
	end

	local modded = _.modArgs(function(a)
		return a
	end, {increment, increment}, pow)

	assert(modded(3) == 25)
	assert(modded(4) == 36)
	assert(modded(5) == 49)
end

local function test_negate( ... )
	local isEven = function (n)
		return n % 2 == 0
	end

	local isOdd = _.negate(isEven)

	assert(_.str(_.filter({1, 2, 3, 4, 5, 6}, isEven)) == '{2, 4, 6}')
	assert(_.str(_.filter({1, 2, 3, 4, 5, 6}, isOdd)) == '{1, 3, 5}')
end

local function test_once()
	local createApp = function(version)
		-- print('App created with version '..version)
		return version
	end
	local initialize = _.once(createApp)
	assert(initialize(1.1) == 1.1)
	assert(initialize(1.1) == 1.1)
end

local function test_rearg()
	local rearged = _.rearg(function(a, b, c)
	   return {a, b, c};
	end, 2, 1, 3)
	assert(_.str(rearged('a', 'b', 'c')) == '{"b", "a", "c"}')
	assert(_.str(rearged('b', 'a', 'c')) == '{"a", "b", "c"}')
end

local function test_args()
	assert(_.str(_.args({1, 2, 3})) == '1')
end

local function test_bool()
	assert(_.bool({1, 2, 3}) == false)
	assert(_.bool("123") == true)
	assert(_.bool(0) == false)
	assert(_.bool(function(a) return a end, "555") == true)
end

local function test_func()
	local f = _.func(1, 2, 3)
 	assert(_.str(f()) == '1')
end

local function test_gt()
	assert(_.gt(1, 3) == false)
	assert(_.gt(1, '3') == false)
	assert(_.gt({}, 3) == false)
end

local function test_gte()
	assert(_.gte(1, 3) == false)
	assert(_.gte(3, '3') == true)
	assert(_.gte({}, 3) == false)
end

local function test_isBoolean()
	assert(_.isBoolean('x') == false)
	assert(_.isBoolean(false) == true)
end

local function test_isEmpty()
	assert(_.isEmpty(true) == true)
	assert(_.isEmpty(1) == true)
	assert(_.isEmpty({1}) == false)
	assert(_.isEmpty({a=1}) == false)
end

local function test_isFunction()
	assert(_.isFunction(function() end) == true)
	assert(_.isFunction(1) == false)	
end

local function test_isNil()
	assert(_.isNil(variable) == true)
 	local variable = 1
 	assert(_.isNil(variable) == false)
end

local function test_isNumber()
	assert(_.isNumber(1) == true)
	assert(_.isNumber('1') == false)
end

local function test_isString()
	assert(_.isString(1) == false)
	assert(_.isString('1') == true)
end

local function test_isTable()
	assert(_.isTable(1) == false)
	assert(_.isTable({'1'}) == true)
end

local function test_lt()
	assert(_.lt(1, 3) == true)
	assert(_.lt(false, 3) == false)
	assert(_.lt({}, 3) == false)
end

local function test_lte()
	assert(_.lte(1, 3) == true)
	assert(_.lte('3', 3) == true)
	assert(_.lte({}, 3) == false)
end

local function test_num()
 	assert(_.num({1, 2, 3}) == 0) 
 	assert(_.num("123") == 123)
	assert(_.num(true) == 1)
  	assert(_.num(function(a) return a end, "555") == 555)
end

local function test_str()
	assert(_.str({1, 2, 3, 4, {k=2, {'x', 'y'}}}) == '{1, 2, 3, 4, {{"x", "y"}, ["k"]=2}}')
	assert(_.str({1, 2, 3, 4, function(a) return a end}, 5) == '{1, 2, 3, 4, 5}')
end

local function test_table()
	assert(_.str(_.table(1, 2, 3)) == '{1, 2, 3, ["n"]=3}')
	assert(_.str(_.table('123')) == '{"123", ["n"]=1}')
end
 


local function test_inRange()
	assert(_.inRange(-3, -4, 8) == true)
	assert(_.inRange(-3, -1, 8) == false)
end

local function test_findKey()
	assert(_.str(_.findKey({a={a = 1}, b={a = 2}, c={a = 3, x = 1}}, 
	function(v)
	    return v.a == 3
	end)) == 'c')
end

local function test_findLastKey()
	assert(_.str(_.findLastKey({a={a = 1}, b={a = 2}, c={a = 3, x = 1}}, 
	function(v)
	    return v.a == 3
	end)) == 'c')
end

local function test_functions()
	assert(_.str(_.functions(table)) == 
		'{"concat", "insert", "maxn", "pack", "remove", "sort", "unpack"}')
end

local function test_assign()
  local object = {
    a = 0,
  }
  local one = {
    a = 1,
  }
  local two = {
    b = 3,
  }

  _.assign(object, one, two)

  assert(object.a == 1)
  assert(object.b == 3)
end

local function test_get()
	local object = {a={b={c={d=5}}}}
	assert(_.get(object, {'a', 'b', 'c', 'd'}) == 5)
end

local function test_has()
	local object = {a={b={c={d}}}}
	assert(_.has(object, {'a', 'b', 'c'}) == true)
end

local function test_invert()
	local inverted = _.str(_.invert({a='1', b='2', c='2'}, false))
	assert(inverted == '{["1"]="a", ["2"]="c"}' or inverted == '{["2"]="c", ["1"]="a"}')
	inverted = _.str(_.invert({a='1', b='2', c='2'}, true))
	assert(inverted == '{["1"]="a", ["2"]={"b", "c"}}' or inverted == '{["2"]={"b", "c"}, ["1"]="a"}')
end

local function test_keys()
	assert(_.str(_.keys("test")) == '{1, 2, 3, 4}')
	assert(_.str(_.keys({a=1, b=2, c=3})) == '{"a", "b", "c"}')	 
end

local function test_pairs()
	assert(_.str(_.pairs({1, 2, 'x', a='b'})) == '{{1, 1}, {2, 2}, {3, "x"}, {"a", "b"}}')
end

local function test_result()
	local object = {a=5, b={c=function(a) return a end}}
	assert(_.result(object, {'b', 'c'}, nil, 5) == 5)
end

local function test_values()
	assert(_.str(_.values("test")) == '{"t", "e", "s", "t"}')
	assert(_.str(_.values({a=1, b=2, c=3})) == '{1, 2, 3}')
end
