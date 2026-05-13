local Q = {}
local function add(subjectBase, subjectIds, topicId, id, difficulty, commandTerm, prompt, options, answer, explanation, commonMistake, tags)
	table.insert(Q, {
		id = id,
		subjectBase = subjectBase,
		subjectIds = subjectIds,
		topicId = topicId,
		subtopic = tags[1],
		learningObjective = "Progress from recognition to application and explanation in the topic ladder.",
		difficulty = difficulty,
		commandTerm = commandTerm,
		type = "multiple_choice",
		prompt = prompt,
		options = options,
		answer = answer,
		acceptedAnswers = { tostring(options[answer]) },
		acceptedKeywords = {},
		markscheme = { explanation },
		explanation = explanation,
		commonMistake = commonMistake,
		tags = tags,
		xp = 10 + difficulty * 8,
		damage = 20 + difficulty * 7,
		masteryImpact = { [topicId] = difficulty + 1 },
		sourceNote = "Original IB Realms seed question.",
	})
end

add("maths", { "math_aa_hl", "math_ai_sl" }, "math_functions", "math_func_l1_notation", 1, "state", "If f(x)=2x+3, what does f(4) mean?", { "The input is 4, so substitute x=4", "Multiply f by 4", "The domain is only 4", "The graph has no y-values" }, 1, "Function notation f(4) asks for the output when x is 4.", "Do not treat f as a variable multiplied by 4.", { "notation", "recognition" })
add("maths", { "math_aa_hl", "math_ai_sl" }, "math_functions", "math_func_l2_domain", 2, "explain", "For g(x)=1/(x-2), why is x=2 excluded from the domain?", { "It makes the denominator zero", "It makes the graph blue", "All positive numbers are excluded", "It is always the maximum value" }, 1, "Division by zero is undefined, so x=2 cannot be an input.", "The restriction comes from the denominator, not from the graph's colour or appearance.", { "domain", "understanding" })
add("maths", { "math_aa_hl", "math_ai_sl" }, "math_functions", "math_func_l3_transform", 3, "apply", "Compared with y=f(x), what does y=f(x-3) do to the graph?", { "Shifts it 3 units right", "Shifts it 3 units left", "Stretches vertically by 3", "Reflects in the x-axis" }, 1, "Inside transformations are reversed: x-3 means the original input occurs 3 units later, so the graph moves right.", "A common mistake is thinking x-3 shifts left because of the minus sign.", { "transformations", "application" })
add("maths", { "math_aa_hl", "math_ai_sl" }, "math_trigonometry", "math_trig_l1_ratio", 1, "identify", "In a right triangle, which ratio is sin(theta)?", { "opposite/hypotenuse", "adjacent/hypotenuse", "opposite/adjacent", "hypotenuse/opposite" }, 1, "Sine is opposite divided by hypotenuse in a right triangle.", "Mixing sine and cosine is common; label the sides relative to the angle first.", { "sine", "recognition" })
add("maths", { "math_aa_hl", "math_ai_sl" }, "math_trigonometry", "math_trig_l3_rule", 3, "apply", "You know two sides and the included angle of a triangle. Which rule is usually suitable to find the third side?", { "Cosine rule", "Sine rule", "Product rule", "Chain rule" }, 1, "The cosine rule is designed for SAS or SSS triangle problems.", "The sine rule needs an opposite side-angle pair.", { "cosine_rule", "application" })
add("maths", { "math_aa_hl" }, "math_calculus", "math_calc_l1_derivative", 1, "state", "What does the derivative represent graphically?", { "Gradient of the curve at a point", "Area of a rectangle only", "The y-intercept always", "The domain restriction only" }, 1, "A derivative gives the instantaneous rate of change or tangent gradient.", "Area under a curve is linked to integration, not differentiation.", { "differentiation", "recognition" })
add("maths", { "math_aa_hl" }, "math_calculus", "math_calc_l3_stationary", 3, "apply", "At a stationary point of a differentiable curve, what is true about dy/dx?", { "dy/dx = 0", "dy/dx is always 1", "The function is undefined", "The x-value must be negative" }, 1, "Stationary points occur where the tangent gradient is zero, before classification.", "A zero derivative does not automatically tell you whether it is a max, min, or inflection.", { "stationary_points", "application" })
add("maths", { "math_aa_hl", "math_ai_sl" }, "math_probability", "math_prob_l2_independent", 2, "explain", "What does it mean for two events to be independent?", { "One event does not change the probability of the other", "They cannot both happen", "They are always equally likely", "They must happen together" }, 1, "Independence means knowing one event occurred does not affect the probability of the other.", "Mutually exclusive means both cannot occur together; that is different from independent.", { "independence", "understanding" })

add("physics", { "physics_hl", "physics_sl" }, "physics_kinematics", "phys_kin_l1_velocity", 1, "state", "Velocity differs from speed because velocity includes...", { "direction", "mass", "temperature", "colour" }, 1, "Velocity is a vector, so it includes magnitude and direction.", "Speed is scalar and does not include direction.", { "velocity", "recognition" })
add("physics", { "physics_hl", "physics_sl" }, "physics_kinematics", "phys_kin_l2_graph", 2, "explain", "On a displacement-time graph, what does gradient represent?", { "Velocity", "Acceleration directly", "Mass", "Force" }, 1, "Gradient of displacement-time gives velocity because it is change in displacement divided by time.", "Acceleration is the gradient of a velocity-time graph.", { "graphs", "understanding" })
add("physics", { "physics_hl", "physics_sl" }, "physics_kinematics", "phys_kin_l3_suvat", 3, "apply", "A car starts from rest and accelerates uniformly. Which variable is initially zero?", { "u", "v", "a", "s" }, 1, "Starting from rest means initial velocity u = 0.", "Final velocity v is not necessarily zero after acceleration.", { "suvat", "application" })
add("physics", { "physics_hl", "physics_sl" }, "physics_mechanics", "phys_mech_l1_newton", 1, "identify", "Which law links resultant force, mass, and acceleration?", { "Newton's second law", "Ohm's law", "Hooke's law only", "Snell's law" }, 1, "Newton's second law is commonly written F = ma.", "Weight uses W = mg, which is a force but not the full resultant force relationship.", { "newton_laws", "recognition" })
add("physics", { "physics_hl", "physics_sl" }, "physics_energy", "phys_energy_l2_ke", 2, "calculate", "Which formula gives kinetic energy?", { "1/2 mv^2", "mgh", "F/A", "v/f" }, 1, "Kinetic energy is 1/2 mv^2, so velocity is squared.", "Forgetting the squared velocity is a common energy calculation error.", { "kinetic_energy", "understanding" })
add("physics", { "physics_hl", "physics_sl" }, "physics_waves", "phys_waves_l2_speed", 2, "calculate", "Which wave equation links speed, frequency, and wavelength?", { "v = fλ", "F = ma", "E = mc", "p = mv only" }, 1, "Wave speed equals frequency multiplied by wavelength.", "Do not confuse wave speed with particle speed in the medium.", { "wave_speed", "understanding" })

add("design_technology", { "dt_hl", "dt_sl" }, "dt_design", "dt_design_l1_need", 1, "state", "Why begin with user needs before sketching a product?", { "Design success depends on solving the user's real problem", "It makes testing impossible", "It removes all constraints", "It guarantees the lowest cost" }, 1, "User-centred design starts by understanding the user's problem and context.", "A product that looks impressive can still fail if it does not solve the user's need.", { "user_needs", "recognition" })
add("design_technology", { "dt_hl", "dt_sl" }, "dt_design", "dt_design_l3_spec", 3, "apply", "A water bottle for hikers must be light, durable, and easy to grip. What are these examples of?", { "Design specification criteria", "Random decoration", "Only marketing slogans", "Finished manufacturing methods" }, 1, "Criteria translate user needs and context into requirements that can be tested.", "A vague wish is not enough; criteria should guide evaluation.", { "specifications", "application" })
add("design_technology", { "dt_hl", "dt_sl" }, "dt_materials", "dt_mat_l2_property", 2, "explain", "Why does material selection depend on product context?", { "Different properties suit different loads, costs, users, and environments", "All materials behave the same", "Only colour matters", "Testing is never useful" }, 1, "Material choice should match required properties such as strength, durability, weight, cost, sustainability, and manufacturing method.", "Choosing material by appearance alone ignores function and safety.", { "materials", "understanding" })

return Q
