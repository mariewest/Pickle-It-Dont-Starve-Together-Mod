-- Global table for recipes
pickleit_Recipes = {}

-- Add a pickled food recipe (called by CreatePickledPrefab, but can be called by anything)
function pickleit_AddRecipe(source, result)
	if source ~= nil and result ~= nil then
		pickleit_Recipes[source] = result
		return true
	end
	
	return false
end