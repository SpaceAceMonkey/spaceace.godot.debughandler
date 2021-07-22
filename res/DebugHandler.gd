extends Node

enum env {
	ALL = 0b1111111111111111,
	DEBUG = 1,
	PRODUCTION = 2
}

enum level {
	ALL = 0b1111111111111111,
	INFO = 1,
	WARN = 2,
	ERROR = 4,
	INFO_ERROR = 5,
	INFO_WARN = 3
}


func _ready():
	self.debug("DebugHandler ready")


# Save yourself a few keystrokes
func a(message, level = self.level.INFO): # All environments
	return self.print(message, self.env.ALL, level)

func d(message, level = self.level.INFO): # Debug only
	return debug(message, level)

func p(message, level = self.level.INFO): # Production only
	return prod(message, level)




func debug(message, level = self.level.INFO):
	var env = self.env.DEBUG
	self.print(message, env, level)

	return self


func prod(message, level = self.level.INFO):
	var env = self.env.PRODUCTION
	self.print(message, env, level)

	return self


func print(message, env = self.env.DEBUG, level = self.level.INFO):
	if should_print(env):
		# You can OR together multiple levels if you desire multiple outputs.
		if level & self.level.INFO:
			print(message)
		if level & self.level.ERROR:
			push_error(message)
		if level & self.level.WARN:
			push_warning(message)

	return self


func should_print(env):
	var result = false
	if (
		env == self.env.ALL
		|| (env & self.env.PRODUCTION && !OS.is_debug_build())
		|| (!(env & self.env.PRODUCTION) && OS.is_debug_build())
	):
		result = true

	return result

