local Q = {}
local function add(subjectBase, subjectIds, topicId, id, difficulty, commandTerm, prompt, options, answer, explanation, commonMistake, tags)
	table.insert(Q, {
		id = id,
		subjectBase = subjectBase,
		subjectIds = subjectIds,
		topicId = topicId,
		subtopic = tags[1],
		learningObjective = "Apply topic knowledge in context and learn from targeted feedback.",
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

add("business", { "business_hl", "business_sl" }, "business_strategy", "bus_strat_l1_swot", 1, "identify", "In SWOT analysis, what does O stand for?", { "Opportunities", "Operations", "Ownership", "Output" }, 1, "Opportunities are external chances a business may exploit.", "Strengths and weaknesses are internal; opportunities and threats are external.", { "swot", "recognition" })
add("business", { "business_hl", "business_sl" }, "business_strategy", "bus_strat_l3_ansoff", 3, "apply", "A café sells its current drinks to a new city. Which Ansoff strategy is closest?", { "Market development", "Product development", "Diversification", "Market penetration only" }, 1, "Market development means taking existing products to new markets.", "Diversification would involve new products and new markets, which is riskier.", { "ansoff", "application" })
add("business", { "business_hl", "business_sl" }, "business_finance", "bus_fin_l2_breakeven", 2, "explain", "Break-even is the point where...", { "total revenue equals total costs", "profit is always maximum", "cash flow is always positive", "fixed costs are zero" }, 1, "At break-even, the business makes neither profit nor loss because total revenue equals total costs.", "Profit can rise after break-even, but break-even itself is not maximum profit.", { "break_even", "understanding" })
add("business", { "business_hl", "business_sl" }, "business_marketing", "bus_mark_l3_segment", 3, "apply", "A brand designs different adverts for teenagers and retirees. Which marketing idea is it using?", { "Segmentation and targeting", "Batch production only", "Random sampling only", "Autocratic leadership" }, 1, "The business is dividing the market into groups and aiming messages at specific segments.", "Promotion is involved, but the key strategic idea is segmentation and targeting.", { "segmentation", "application" })

add("economics", { "economics_hl", "economics_sl" }, "economics_markets", "econ_mark_l1_demand", 1, "state", "Demand is best described as...", { "Quantity consumers are willing and able to buy at different prices", "Any amount firms produce", "Only government spending", "A fixed number that never changes" }, 1, "Demand requires willingness and ability to buy at different possible prices.", "Wanting something without ability to pay is not effective demand.", { "demand", "recognition" })
add("economics", { "economics_hl", "economics_sl" }, "economics_markets", "econ_mark_l2_shift", 2, "explain", "If consumer income rises and a normal good becomes more popular, what happens to demand?", { "Demand shifts right", "Supply shifts left", "Quantity supplied becomes zero", "Price is fixed forever" }, 1, "Higher income for a normal good increases demand at each price, shifting demand right.", "A change in price causes movement along a demand curve, not a shift of demand.", { "shifts", "understanding" })
add("economics", { "economics_hl", "economics_sl" }, "economics_market_failure", "econ_fail_l2_externality", 2, "explain", "A negative externality occurs when...", { "A third party suffers a cost not reflected in market price", "A firm earns any profit", "Demand equals supply", "Consumers receive a private benefit" }, 1, "Negative externalities impose external costs on others, so market outcomes may overproduce the good.", "Private cost is paid by the decision maker; external cost affects others.", { "externalities", "understanding" })
add("economics", { "economics_hl", "economics_sl" }, "economics_macro", "econ_macro_l3_policy", 3, "apply", "A central bank raises interest rates to reduce inflation pressure. Which policy is this?", { "Monetary policy", "Fiscal policy", "Trade protection", "Price ceiling only" }, 1, "Interest rates are a monetary policy tool used to influence borrowing, spending, and inflation.", "Fiscal policy uses government spending and taxation.", { "monetary_policy", "application" })

add("ess", { "ess_sl" }, "ess_systems", "ess_sys_l1_store", 1, "identify", "In a systems model, a store is...", { "A component where matter or energy is held", "Only a shop", "A random opinion", "A type of exam command term" }, 1, "A store holds matter or energy within a system, such as biomass in a forest.", "Inputs and outputs move across boundaries; stores hold material or energy inside.", { "stores", "recognition" })
add("ess", { "ess_sl" }, "ess_systems", "ess_sys_l3_feedback", 3, "apply", "A process reduces the original change and returns a system toward equilibrium. What type of feedback is this?", { "Negative feedback", "Positive feedback", "No feedback", "Random feedback" }, 1, "Negative feedback counteracts change and stabilises a system.", "Positive feedback amplifies change and can move systems away from equilibrium.", { "feedback", "application" })
add("ess", { "ess_sl" }, "ess_ecosystems", "ess_eco_l2_energy", 2, "explain", "Why does available energy usually decrease at higher trophic levels?", { "Energy is lost through respiration, heat, waste, and uneaten biomass", "Energy is created at each level", "Predators always photosynthesise", "Food webs have no transfers" }, 1, "Energy transfer is inefficient, so less energy is available to organisms at higher trophic levels.", "Matter may cycle, but energy flows and is dissipated.", { "trophic_levels", "understanding" })

add("languages", { "japanese_b" }, "language_core", "jp_vocab_l1_hello", 1, "identify", "In a polite first meeting, which Japanese greeting means hello/good afternoon?", { "こんにちは", "ありがとう", "さようなら", "水" }, 1, "こんにちは is a common greeting for hello or good afternoon.", "ありがとう means thank you, not hello.", { "vocabulary", "japanese", "recognition" })
add("languages", { "japanese_b" }, "language_core", "jp_grammar_l2_particle", 2, "explain", "In 私は学生です, what does は mainly mark?", { "The topic of the sentence", "Past tense", "A question", "Plural only" }, 1, "は marks the topic, so the sentence is about 私, 'I'.", "Particles mark grammatical roles; they are not just decoration.", { "grammar", "japanese", "understanding" })
add("languages", { "french_b" }, "language_core", "fr_vocab_l1_cafe", 1, "identify", "At a café, what does 'l'addition' usually mean?", { "The bill", "The train", "A museum", "A book" }, 1, "L'addition is the bill in a restaurant or café context.", "Context matters: this is not mathematical addition in this situation.", { "vocabulary", "french", "recognition" })
add("languages", { "french_b" }, "language_core", "fr_grammar_l2_agree", 2, "explain", "Which phrase has correct feminine agreement for 'a small house'?", { "une petite maison", "un petit maison", "une petit maison", "un petite maison" }, 1, "Maison is feminine, so the article and adjective should agree: une petite maison.", "French adjectives and articles often need gender agreement.", { "grammar", "french", "understanding" })
add("languages", { "spanish_b" }, "language_core", "es_vocab_l1_market", 1, "identify", "In a market, what does '¿Cuánto cuesta?' ask?", { "How much does it cost?", "Where is the station?", "What time is it?", "Who are you?" }, 1, "¿Cuánto cuesta? asks about the price of something.", "Cuánto signals quantity or amount; context points to price.", { "vocabulary", "spanish", "recognition" })
add("languages", { "spanish_b" }, "language_core", "es_grammar_l2_verb", 2, "explain", "Choose the correct sentence for 'I speak Spanish.'", { "Hablo español", "Hablas español", "Habla español", "Hablamos español" }, 1, "Hablo is the first-person singular form of hablar.", "Verb endings must match the subject; hablas means you speak.", { "grammar", "spanish", "understanding" })

return Q
