-- CurriculumData describes the full intended IB Realms learning campaign at topic level.
-- It is deliberately separate from SubjectData so designers can extend learning ladders,
-- memory anchors, enemies, and assessment intent without touching UI or combat code.
local CurriculumData = {
	TopicLadders = {
		cs_hardware = {
			title = "Boot Sector: Hardware",
			scope = "CPU, ALU, control unit, registers, cache, RAM, ROM, buses, secondary storage, GPU, embedded systems, peripherals, performance factors, and real device bottlenecks.",
			visualMemory = "Neon circuit floor links buses to server columns; cache nodes sit closest to the CPU core; slower storage vaults are further away.",
			enemies = { "Byte Slime", "Cache Wraith", "Bus Phantom", "Broken Processor" },
			ladder = {
				"Recognise core components and match definitions.",
				"Explain why components work and how they connect.",
				"Apply hardware choices to devices, games, editors, databases, and simulations.",
				"Analyse bottlenecks using cause-and-effect explanation.",
				"Evaluate upgrade decisions and justify the best repair for a scenario.",
			},
		},
		cs_data = {
			title = "Binary Vault: Data Representation",
			scope = "Binary, hexadecimal, character sets, image representation, sound representation, compression, encryption concepts, Boolean logic, AND, OR, NOT, truth tables, and logic circuits.",
			visualMemory = "Locked vault doors use binary panels; image walls show pixel grids; logic gates open only when truth-table conditions are met.",
			enemies = { "Bit Bat", "Pixel Shade", "Compression Imp", "Logic Lock" },
		},
		cs_algorithms = {
			title = "Algorithm Arena",
			scope = "Trace tables, sequence, selection, iteration, loops, conditions, searching, sorting, pseudocode, decomposition, abstraction, validation, and debugging.",
			visualMemory = "Arena lanes represent sequence, branching doors represent selection, loop rails circle back, and trace tiles show variable changes.",
			enemies = { "Trace Sprite", "Loop Snare", "Condition Guard", "Broken Algorithm" },
		},
		cs_databases = {
			title = "Database Archives",
			scope = "Tables, records, fields, primary keys, foreign keys, relationships, validation, queries, data types, data integrity, redundancy, and normalisation basics.",
			visualMemory = "Archive shelves are tables, glowing record cards slide into fields, and key doors connect related rooms.",
			enemies = { "Duplicate Record", "Null Key", "Query Shade", "Redundancy Hydra" },
		},
		cs_oop = {
			title = "OOP Citadel",
			scope = "Classes, objects, attributes, methods, constructors, inheritance, encapsulation, polymorphism, class diagrams, and object interactions.",
			visualMemory = "Blueprint halls instantiate guards; inheritance towers share features; encapsulation shields protect internal state.",
			enemies = { "Loose Object", "Public Field", "Constructor Golem", "Polymorph Knight" },
		},
		math_functions = {
			title = "Function Floor",
			scope = "Function notation, substitution, domain, range, transformations, inverse functions, composite functions, roots, intersections, graphs, modelling, and restrictions.",
			visualMemory = "Graph gates require valid inputs; transformation bridges move in the opposite direction for inside changes.",
			enemies = { "Domain Gate", "Transform Shade", "Inverse Mirror", "Composite Sentinel" },
		},
		math_trigonometry = {
			title = "Trigonometry Gate",
			scope = "Sine, cosine, tangent, exact values, radians, identities, equations, graphs, sine rule, cosine rule, area formula, and modelling.",
			visualMemory = "Unit-circle pads, angle gates, wave paths, and triangle locks attach ratios and rules to places.",
			enemies = { "Ratio Wisp", "Radian Keeper", "Identity Shade", "Trig Gatekeeper" },
		},
		math_calculus = {
			title = "Calculus Spire",
			scope = "Differentiation, tangents, normals, stationary points, optimisation, integration, area, kinematics applications, chain rule, product rule, and interpretation.",
			visualMemory = "Slope beams climb the spire, zero-gradient platforms mark stationary points, and area fields glow under curves.",
			enemies = { "Slope Spark", "Chain Wraith", "Area Phantom", "Optimisation Titan" },
		},
		math_vectors = {
			title = "Vector Bridge",
			scope = "Vector notation, magnitude, direction, unit vectors, position vectors, lines, intersections, angles, and geometric reasoning.",
			visualMemory = "Arrow bridges show magnitude and direction, while line beams intersect above coordinate grids.",
			enemies = { "Direction Mote", "Magnitude Guard", "Line Phantom", "Vector Bridgekeeper" },
		},
		math_probability = {
			title = "Probability Vault and Data District",
			scope = "Sample spaces, conditional probability, independence, mutually exclusive events, counting, distributions, expectation, variance, regression, correlation, and interpretation.",
			visualMemory = "Vault doors split sample spaces; conditional locks change after evidence; data streets show correlation warning signs.",
			enemies = { "Sample Goblin", "Conditional Shade", "Variance Imp", "Correlation Mirage" },
		},
		physics_kinematics = {
			title = "Kinematics Canyon",
			scope = "Distance, displacement, speed, velocity, acceleration, motion graphs, SUVAT, free fall, units, graph gradient, and graph area.",
			visualMemory = "Motion tracks and graph screens place gradient and area ideas beside ramps and arrows.",
			enemies = { "Velocity Wisp", "Graph Shade", "SUVAT Drone", "Freefall Spectre" },
		},
		physics_mechanics = {
			title = "Force Bridge",
			scope = "Forces, free body diagrams, resultant force, Newton laws, friction, weight, normal reaction, momentum, impulse, collisions, and conservation.",
			visualMemory = "Suspended bridges display force arrows; impact pads demonstrate impulse and momentum transfer.",
			enemies = { "Friction Grub", "Resultant Golem", "Impulse Wraith", "Momentum Crusher" },
		},
		physics_energy = {
			title = "Energy Reactor",
			scope = "Work, kinetic energy, gravitational potential energy, power, efficiency, conservation, transfers, and system boundaries.",
			visualMemory = "Energy conduits flow between stores, while efficiency vents show wasted transfers.",
			enemies = { "Joule Spark", "Power Leech", "Efficiency Shade", "Reactor Overload" },
		},
		physics_waves = {
			title = "Wave Chamber",
			scope = "Frequency, period, wavelength, wave speed, transverse waves, longitudinal waves, superposition, standing waves, resonance, diffraction, interference, and Doppler effect.",
			visualMemory = "Wave machines, resonance gates, and oscillating platforms turn equations into spatial rhythm.",
			enemies = { "Frequency Flicker", "Resonance Wraith", "Interference Twins", "Doppler Phantom" },
		},
		business_strategy = {
			title = "Strategy Street",
			scope = "Objectives, stakeholders, SWOT, Ansoff, growth, decision trees, leadership context, culture, and evaluation of options.",
			visualMemory = "Billboards show objectives and stakeholders; intersections force strategic choices with visible tradeoffs.",
			enemies = { "Vague Objective", "Stakeholder Clash", "Growth Risk", "Strategy Void" },
		},
		business_finance = {
			title = "Finance District",
			scope = "Revenue, costs, profit, break even, contribution, cash flow, final accounts, ratios, investment appraisal, and financial interpretation.",
			visualMemory = "Vaults, graph floors, and cash-flow lanes connect calculations to business meaning.",
			enemies = { "Cost Creep", "Cashflow Leak", "Ratio Shade", "Break-even Beast" },
		},
		business_marketing = {
			title = "Marketing Avenue",
			scope = "Market research, segmentation, targeting, positioning, marketing mix, branding, promotion, e-commerce, and customer behaviour.",
			visualMemory = "Customer NPC groups stand by segments; product stands and billboards represent the marketing mix.",
			enemies = { "Misread Segment", "Brand Blur", "Promotion Noise", "Positioning Phantom" },
		},
		economics_markets = {
			title = "Market Square",
			scope = "Demand, supply, equilibrium, shifts, elasticity, consumer behaviour, producer behaviour, surplus, shortage, and price signals.",
			visualMemory = "Graph panels move demand and supply boards; price signs rise or fall after shocks.",
			enemies = { "Demand Drift", "Supply Shock", "Elasticity Imp", "Equilibrium Keeper" },
		},
		economics_market_failure = {
			title = "Market Failure Field",
			scope = "Externalities, public goods, common access resources, merit goods, demerit goods, asymmetric information, tax, subsidy, regulation, and evaluation.",
			visualMemory = "Pollution clouds, subsidy fields, tax barriers, and shared-resource lakes display intervention tradeoffs.",
			enemies = { "External Cost", "Free Rider", "Policy Backfire", "Welfare Hydra" },
		},
		economics_macro = {
			title = "Macro Central Bank",
			scope = "Growth, inflation, unemployment, fiscal policy, monetary policy, supply side policy, exchange rates, and macroeconomic objectives.",
			visualMemory = "Interest-rate levers, inflation storms, employment boards, and objective dials show policy tradeoffs.",
			enemies = { "Inflation Spark", "Unemployment Shade", "Policy Lag", "Macro Tradeoff" },
		},
		ess_systems = {
			title = "Systems Camp",
			scope = "Inputs, outputs, stores, flows, feedback, equilibrium, resilience, tipping points, sustainability, and environmental values.",
			visualMemory = "Research camp arrows connect stores and flows; feedback loops light up as systems stabilise or amplify.",
			enemies = { "Broken Flow", "Feedback Surge", "Tipping Shade", "Systems Hydra" },
		},
		ess_ecosystems = {
			title = "Ecosystem Trail",
			scope = "Species, populations, communities, food webs, trophic levels, energy flow, biodiversity, succession, conservation, and human impact.",
			visualMemory = "Food-web paths and organism markers show energy transfer and ecosystem stability.",
			enemies = { "Trophic Leak", "Biodiversity Loss", "Succession Ghost", "Impact Beast" },
		},
		dt_design = {
			title = "Design Brief Bench",
			scope = "User needs, design briefs, specifications, constraints, aesthetics, function, ergonomics, inclusive design, and evaluation criteria.",
			visualMemory = "Blueprint tables turn user panels into testable specification gates.",
			enemies = { "Vague Need", "Constraint Knot", "Ergonomic Error", "Brief Breaker" },
		},
		dt_materials = {
			title = "Materials Lab",
			scope = "Material properties, selection, sustainability, manufacturing, testing, stress, durability, cost, and lifecycle.",
			visualMemory = "Material shelves, stress rigs, and lifecycle loops connect properties to tradeoffs.",
			enemies = { "Brittle Sample", "Cost Spike", "Lifecycle Shade", "Material Mismatch" },
		},
		language_core = {
			title = "Vocab Gate and Grammar Shrine",
			scope = "Vocabulary, grammar, reading, listening, speaking, writing, text types, culture, dialogue, accuracy, fluency, and contextual communication.",
			visualMemory = "Signs, NPC dialogue, market objects, shrines, and travel choices embed language in context instead of isolated flashcards.",
			enemies = { "Vocab Gate", "Grammar Knot", "Dialogue Duelist", "Culture Mirror" },
		},
	},
}

function CurriculumData.GetTopic(topicId)
	return CurriculumData.TopicLadders[topicId]
end

return CurriculumData
