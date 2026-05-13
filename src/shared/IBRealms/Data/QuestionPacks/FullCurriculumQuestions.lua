local Q = {}

local function add(question)
	question.sourceNote = question.sourceNote or "Original IB Realms full-curriculum seed question."
	question.learningObjective = question.learningObjective or "Progress through recognition, understanding, application, analysis, and synthesis for this topic."
	question.acceptedAnswers = question.acceptedAnswers or {}
	question.acceptedKeywords = question.acceptedKeywords or {}
	question.markscheme = question.markscheme or { question.explanation }
	question.xp = question.xp or (10 + question.difficulty * 8)
	question.damage = question.damage or (22 + question.difficulty * 7)
	question.masteryImpact = question.masteryImpact or { [question.topicId] = question.difficulty + 1 }
	table.insert(Q, question)
end

local function mcq(subjectBase, subjectIds, topicId, id, difficulty, commandTerm, prompt, options, answer, explanation, commonMistake, tags)
	add({
		id = id,
		subjectBase = subjectBase,
		subjectIds = subjectIds,
		topicId = topicId,
		subtopic = tags[1],
		difficulty = difficulty,
		commandTerm = commandTerm,
		type = "multiple_choice",
		prompt = prompt,
		options = options,
		answer = answer,
		acceptedAnswers = { tostring(options[answer]) },
		explanation = explanation,
		commonMistake = commonMistake,
		tags = tags,
	})
end

local function text(subjectBase, subjectIds, topicId, id, difficulty, commandTerm, prompt, keywords, markscheme, explanation, commonMistake, tags)
	add({
		id = id,
		subjectBase = subjectBase,
		subjectIds = subjectIds,
		topicId = topicId,
		subtopic = tags[1],
		difficulty = difficulty,
		commandTerm = commandTerm,
		type = "text",
		prompt = prompt,
		options = {},
		answer = table.concat(keywords, ", "),
		acceptedKeywords = keywords,
		markscheme = markscheme,
		explanation = explanation,
		commonMistake = commonMistake,
		tags = tags,
	})
end

-- Computer Science: adds full five-step ladders to topics that were previously only lightly seeded.
mcq("computer_science", { "cs_hl", "cs_sl" }, "cs_data", "full_cs_data_l1_hex", 1, "identify", "Which base is hexadecimal?", { "Base 2", "Base 10", "Base 16", "Base 60" }, 3, "Hexadecimal is base 16 and uses symbols 0-9 and A-F.", "Hex is often confused with binary because both are used in low-level data representation.", { "hexadecimal", "recognition" })
mcq("computer_science", { "cs_hl", "cs_sl" }, "cs_data", "full_cs_data_l4_sound", 4, "analyse", "A sound file doubles its sample rate while keeping duration and bit depth the same. What happens to raw file size and quality potential?", { "Raw size roughly doubles and higher frequencies can be represented", "Raw size halves", "Only image resolution changes", "Compression becomes impossible" }, 1, "More samples per second means more stored values, increasing raw file size and allowing better representation of changing sound.", "A common mistake is discussing colour depth, which belongs to images, not sound.", { "sound", "sampling", "analysis" })
text("computer_science", { "cs_hl", "cs_sl" }, "cs_data", "full_cs_data_l5_compression", 5, "evaluate", "A school wants to store lecture videos with smaller files but readable text on slides. Evaluate lossy versus lossless compression for this use.", { "lossy", "lossless", "quality" }, { "Identifies lossy can greatly reduce video size", "Explains excessive loss may make slide text unreadable", "Mentions lossless preserves data but may reduce size less" }, "The best choice depends on the acceptable quality loss. Lossy compression may be suitable if tuned carefully, while lossless preserves exact data but may not shrink video enough.", "Do not say lossy is always bad; it is often useful when controlled for the context.", { "compression", "boss", "synthesis" })
mcq("computer_science", { "cs_hl", "cs_sl" }, "cs_algorithms", "full_cs_alg_l4_trace", 4, "analyse", "A trace table is most useful because it...", { "records variable changes step by step", "stores files permanently", "converts all code to binary", "replaces testing completely" }, 1, "Trace tables expose how variables change, making logic errors easier to find.", "A trace table supports testing and debugging but does not replace all testing.", { "trace_tables", "analysis" })
mcq("computer_science", { "cs_hl", "cs_sl" }, "cs_databases", "full_cs_db_l2_validation", 2, "explain", "A date-of-birth field rejects 31/02/2026. What is being used?", { "Validation", "Sorting", "Encryption only", "A foreign key" }, 1, "Validation checks whether data is reasonable or follows rules before it is accepted.", "Validation cannot prove data is true; it only checks it meets rules.", { "validation", "understanding" })
mcq("computer_science", { "cs_hl", "cs_sl" }, "cs_oop", "full_cs_oop_l2_encap", 2, "explain", "Why is encapsulation useful?", { "It protects internal state and controls access through methods", "It deletes all methods", "It makes every variable public", "It prevents objects from existing" }, 1, "Encapsulation keeps data and behaviour together while controlling how internal data is changed.", "Encapsulation is not about hiding the whole program; it is about controlled access.", { "encapsulation", "understanding" })

-- Maths full ladders.
text("maths", { "math_aa_hl", "math_ai_sl" }, "math_functions", "full_math_func_l5_model", 5, "evaluate", "A model f(x)=1/(x-5) is used for a real-world input x. Explain why stating the domain is essential before using predictions.", { "domain", "undefined", "context" }, { "Identifies x=5 is excluded", "Explains real contexts may add further restrictions", "Connects domain to valid predictions" }, "A model only makes sense for valid inputs. Algebra excludes x=5, and the real context may restrict x further, so predictions outside the domain are not reliable.", "Do not treat every algebraic output as meaningful in context.", { "domain", "modelling", "boss" })
mcq("maths", { "math_aa_hl", "math_ai_sl" }, "math_trigonometry", "full_math_trig_l4_radians", 4, "analyse", "Why are radians often preferred in calculus with trigonometric functions?", { "They make derivative relationships such as d/dx sin x = cos x work cleanly", "They remove all angles", "They make every triangle right-angled", "They are only used for degrees" }, 1, "Standard calculus identities for trig functions assume radian measure.", "Radians are a different measure of angle, not a removal of angle.", { "radians", "analysis" })
text("maths", { "math_aa_hl" }, "math_calculus", "full_math_calc_l5_opt", 5, "evaluate", "A student finds a stationary point during an optimisation problem and stops. Explain what else must be checked before claiming a maximum profit.", { "stationary", "maximum", "domain" }, { "Checks nature of stationary point", "Considers endpoints/domain restrictions", "Interprets result in business/context units" }, "A stationary point may be a maximum, minimum, or neither. Optimisation also requires checking the valid domain and interpreting the result in context.", "The common mistake is equating derivative zero with the required optimum automatically.", { "optimisation", "boss", "interpretation" })
mcq("maths", { "math_aa_hl" }, "math_vectors", "full_math_vec_l3_magnitude", 3, "calculate", "A vector is (3, 4). What is its magnitude?", { "5", "7", "12", "25" }, 1, "Magnitude is sqrt(3^2+4^2)=5.", "Adding components gives 7, but magnitude uses Pythagoras.", { "magnitude", "application" })
text("maths", { "math_aa_hl", "math_ai_sl" }, "math_probability", "full_math_prob_l5_correlation", 5, "evaluate", "A scatterplot shows strong positive correlation between revision hours and score. Evaluate whether this proves revision caused the score increase.", { "correlation", "causation", "variables" }, { "States correlation does not prove causation", "Suggests possible confounding variables", "Explains why context and study design matter" }, "A strong correlation supports an association but does not prove causation on its own. Other variables and the study design must be considered.", "Do not write that correlation and causation are the same thing.", { "correlation", "boss", "interpretation" })


text("maths", { "math_aa_hl", "math_ai_sl" }, "math_calculus", "full_math_calc_ai_l5_interpret", 5, "evaluate", "A technology output gives a maximum point for a model. Explain two checks before using it as a real recommendation.", { "domain", "context", "maximum" }, { "Checks the point lies in the valid domain", "Interprets units and context", "Considers model assumptions or endpoints" }, "Technology can find a maximum, but the result must be valid for the model domain and meaningful in the real context.", "Do not copy calculator output without interpreting it.", { "technology", "optimisation", "boss" })
text("maths", { "math_aa_hl" }, "math_vectors", "full_math_vec_l5_intersection", 5, "evaluate", "Two vector line models intersect algebraically outside the physical bridge segment they represent. Explain why the algebraic intersection may not be a valid route point.", { "intersection", "parameter", "context" }, { "Distinguishes infinite mathematical lines from physical segments", "Checks parameter restrictions", "Interprets geometry in context" }, "Vector equations may represent full lines unless parameters are restricted. A physical segment needs parameter/domain checks before accepting an intersection.", "Do not assume every algebraic intersection is valid in the real model.", { "vectors", "boss", "modelling" })

-- Physics full ladders.
text("physics", { "physics_hl", "physics_sl" }, "physics_kinematics", "full_phys_kin_l5_graph", 5, "evaluate", "A velocity-time graph has a positive area but ends at zero velocity. Explain what area and final velocity each tell you.", { "area", "displacement", "velocity" }, { "Area under velocity-time graph gives displacement", "Final velocity being zero means stopped at the end", "Distinguishes final state from total journey" }, "The area gives displacement during the interval, while the final point tells the velocity at the end only. A stopped object may still have moved overall.", "A common error is thinking zero final velocity means zero displacement.", { "graphs", "boss", "displacement" })
mcq("physics", { "physics_hl", "physics_sl" }, "physics_mechanics", "full_phys_mech_l3_impulse", 3, "apply", "A longer collision time for the same momentum change usually reduces...", { "average force", "mass to zero", "momentum change", "all energy transfer" }, 1, "Impulse equals force times time, so increasing time can reduce average force for the same momentum change.", "The momentum change is specified as the same; the force changes because time changes.", { "impulse", "application" })

text("physics", { "physics_hl", "physics_sl" }, "physics_mechanics", "full_phys_mech_l5_collision", 5, "evaluate", "Two carts collide and stick together. Explain how conservation of momentum applies and why kinetic energy may not be conserved.", { "momentum", "kinetic", "collision" }, { "Momentum conserved if external resultant force is negligible", "Kinetic energy can transfer to thermal/sound/deformation", "Identifies perfectly inelastic collision idea" }, "Momentum can be conserved for the system even when kinetic energy decreases because energy is transferred to other stores during deformation, sound, and heating.", "Do not assume all conserved quantities behave the same way in every collision.", { "momentum", "collision", "boss" })

text("physics", { "physics_hl", "physics_sl" }, "physics_energy", "full_phys_energy_l5_efficiency", 5, "evaluate", "A motor lifts a load but becomes hot. Explain how conservation of energy and efficiency both apply.", { "conservation", "useful", "thermal" }, { "Energy is conserved overall", "Only some input energy becomes useful GPE/work", "Thermal transfer to surroundings lowers efficiency" }, "Energy is not destroyed; some becomes useful energy in the lifted load and some is dissipated as thermal energy, so efficiency is less than 100%.", "Do not say energy is lost from the universe; it is transferred or dissipated.", { "efficiency", "boss", "conservation" })
mcq("physics", { "physics_hl", "physics_sl" }, "physics_waves", "full_phys_waves_l4_resonance", 4, "analyse", "Resonance occurs when a system is driven...", { "near its natural frequency, producing large amplitude", "with zero frequency", "only in a vacuum", "without any energy transfer" }, 1, "Driving near natural frequency can transfer energy efficiently and produce large oscillations.", "Resonance is not limited to sound; it can occur in many oscillating systems.", { "resonance", "analysis" })

-- Business full ladders.
text("business", { "business_hl", "business_sl" }, "business_strategy", "full_bus_strat_l5_eval", 5, "evaluate", "A small local bakery considers diversification into online fitness coaching. Evaluate this using Ansoff risk and context.", { "diversification", "risk", "context" }, { "Identifies new product and new market", "Explains high risk due to lack of experience/brand fit", "Mentions possible reward or mitigation" }, "Diversification is high risk because both product and market are new. The bakery may lack expertise and brand fit, though research or partnerships could reduce risk.", "Do not recommend a strategy without applying the business context.", { "ansoff", "boss", "evaluation" })
mcq("business", { "business_hl", "business_sl" }, "business_finance", "full_bus_fin_l3_contribution", 3, "calculate", "If price is $10 and variable cost is $6, contribution per unit is...", { "$4", "$6", "$10", "$16" }, 1, "Contribution per unit equals price minus variable cost: 10 - 6 = 4.", "Do not subtract fixed costs when calculating contribution per unit.", { "contribution", "application" })

text("business", { "business_hl", "business_sl" }, "business_finance", "full_bus_fin_l5_invest", 5, "evaluate", "A project has a high forecast return but weak cash flow in the first six months. Evaluate one reason the business might still reject it.", { "cash", "risk", "liquidity" }, { "Explains liquidity/cash-flow pressure", "Mentions forecast risk or uncertainty", "Balances return against survival/finance constraints" }, "A profitable forecast does not guarantee the business can survive short-term cash outflows. Liquidity, risk, and finance availability affect the decision.", "Do not judge investment only by the headline return.", { "investment", "cash_flow", "boss" })

text("business", { "business_hl", "business_sl" }, "business_marketing", "full_bus_mark_l5_position", 5, "evaluate", "A premium watch brand cuts prices heavily to gain teenagers. Evaluate one possible marketing risk.", { "brand", "positioning", "segment" }, { "Explains premium positioning may be weakened", "Links to target segment mismatch", "Considers short-term sales versus long-term brand value" }, "Heavy discounting may damage premium positioning and confuse loyal customers, even if it attracts a new segment briefly.", "Do not evaluate price in isolation; link it to brand and target market.", { "positioning", "boss", "evaluation" })

-- Economics full ladders.
text("economics", { "economics_hl", "economics_sl" }, "economics_markets", "full_econ_mark_l5_shift", 5, "evaluate", "A drought reduces wheat supply. Explain the likely effect on equilibrium price and quantity, and one limitation of the prediction.", { "supply", "price", "quantity" }, { "Supply shifts left", "Equilibrium price rises and quantity falls", "Mentions limitation such as imports, stocks, elasticity, or policy" }, "A supply decrease creates shortage pressure at the old price, so price tends to rise and quantity falls. The size depends on elasticity, stocks, imports, and interventions.", "Do not describe this as a demand shift; the original shock affects producers' ability to supply.", { "supply_shift", "boss", "equilibrium" })
mcq("economics", { "economics_hl", "economics_sl" }, "economics_market_failure", "full_econ_fail_l3_tax", 3, "apply", "A government taxes a good that creates pollution. What is the intended market-failure logic?", { "Raise private cost to reflect external cost", "Increase overconsumption", "Make the good a public good", "Remove scarcity" }, 1, "A tax can internalise part of the external cost by making producers/consumers face a higher private cost.", "Taxes do not remove scarcity; they change incentives.", { "tax", "externalities", "application" })

text("economics", { "economics_hl", "economics_sl" }, "economics_market_failure", "full_econ_fail_l5_policy", 5, "evaluate", "Evaluate one limitation of using a subsidy to encourage consumption of a merit good.", { "subsidy", "cost", "information" }, { "Explains subsidy can lower price/increase consumption", "Identifies government cost/opportunity cost", "Mentions information failure, targeting, or overconsumption risk" }, "A subsidy can encourage consumption, but it costs public funds and may be poorly targeted if consumers still lack information or if benefits go to people who would buy anyway.", "Do not assume intervention perfectly fixes every market failure.", { "subsidy", "merit_goods", "boss" })

text("economics", { "economics_hl", "economics_sl" }, "economics_macro", "full_econ_macro_l5_tradeoff", 5, "evaluate", "Evaluate one tradeoff a government may face when using expansionary fiscal policy to reduce unemployment.", { "unemployment", "inflation", "budget" }, { "Explains demand may increase employment", "Identifies inflationary pressure or budget deficit risk", "Uses balanced judgement" }, "Expansionary fiscal policy can raise aggregate demand and employment, but may worsen inflation or budget deficits depending on spare capacity and financing.", "Do not treat macro policy as having only benefits.", { "fiscal_policy", "boss", "tradeoffs" })

-- ESS and Design Technology full ladders.
text("ess", { "ess_sl" }, "ess_systems", "full_ess_sys_l5_tipping", 5, "evaluate", "Explain why positive feedback can make an environmental tipping point difficult to reverse.", { "positive", "amplify", "tipping" }, { "Positive feedback amplifies change", "System may cross threshold into a new state", "Reversal may require more than removing the original pressure" }, "Positive feedback reinforces the original change, so after a threshold the system may shift state and resist returning to equilibrium.", "Positive feedback is not 'good feedback'; it means amplifying feedback.", { "feedback", "boss", "tipping_points" })
mcq("ess", { "ess_sl" }, "ess_ecosystems", "full_ess_eco_l4_biodiversity", 4, "analyse", "Why can higher biodiversity increase ecosystem resilience?", { "More species can provide alternative roles and responses after disturbance", "It removes all human impact", "It stops energy loss completely", "It guarantees no extinctions" }, 1, "Biodiversity can provide functional redundancy and varied responses, helping systems recover from disturbance.", "Biodiversity helps resilience but does not make ecosystems invincible.", { "biodiversity", "analysis" })
text("design_technology", { "dt_hl", "dt_sl" }, "dt_design", "full_dt_design_l5_inclusive", 5, "evaluate", "A public ticket machine is attractive but hard for wheelchair users to reach. Evaluate the design against inclusive design and function.", { "inclusive", "user", "function" }, { "Identifies accessibility failure", "Links design to user needs/function", "Balances aesthetics against usability and criteria" }, "A product that excludes a user group fails important functional and inclusive criteria even if it looks attractive. Evaluation must refer to real users and success criteria.", "Do not judge design quality only by appearance.", { "inclusive_design", "boss", "evaluation" })
mcq("design_technology", { "dt_hl", "dt_sl" }, "dt_materials", "full_dt_mat_l4_lifecycle", 4, "analyse", "Why might a more expensive recyclable material be chosen over a cheaper non-recyclable one?", { "Lifecycle and sustainability criteria may justify higher cost", "Cost never matters", "Recycling removes all impacts", "Material properties are irrelevant" }, 1, "Design decisions balance cost with sustainability, performance, user needs, and lifecycle impacts.", "Sustainability does not mean ignoring cost; it means evaluating tradeoffs.", { "sustainability", "analysis" })

-- Languages full ladders.
text("languages", { "japanese_b" }, "language_core", "full_jp_lang_l5_dialogue", 5, "evaluate", "In a polite conversation, explain why choosing です/ます forms may be more appropriate with a teacher than casual forms.", { "polite", "teacher", "context" }, { "Identifies formality/politeness", "Links to relationship/context", "Explains communication effect" }, "Polite forms signal respect and fit the teacher-student context. Register is part of meaning, not just grammar accuracy.", "Do not translate word by word without considering social context.", { "japanese", "dialogue", "boss" })
text("languages", { "french_b" }, "language_core", "full_fr_lang_l5_opinion", 5, "evaluate", "A French B answer says only 'J'aime le film.' Explain how to improve it for a higher-level opinion response.", { "opinion", "because", "detail" }, { "Adds justification", "Adds detail or example", "May use connectives or tense accurately" }, "A stronger response gives an opinion plus reasons and supporting detail, for example linking genre, acting, theme, or personal response.", "Short unsupported opinions rarely show enough communicative depth.", { "french", "writing", "boss" })
text("languages", { "spanish_b" }, "language_core", "full_es_lang_l5_agreement", 5, "evaluate", "A Spanish sentence has good vocabulary but repeated subject-verb agreement errors. Explain why this affects communication and how to improve it.", { "verb", "agreement", "subject" }, { "Explains endings show who performs action", "Connects errors to possible confusion", "Suggests checking subject and verb endings" }, "Verb endings carry meaning in Spanish. Agreement errors can confuse who is doing the action, so checking subject-person-number improves accuracy and fluency.", "Do not treat endings as decorative; they communicate key information.", { "spanish", "grammar", "boss" })

return Q
