local Q = {}

local function mcq(id, topicId, difficulty, commandTerm, prompt, options, answerIndex, explanation, commonMistake, tags, xp, damage, masteryImpact)
	table.insert(Q, {
		id = id,
		subjectBase = "computer_science",
		subjectIds = { "cs_hl", "cs_sl" },
		topicId = topicId,
		subtopic = tags[1],
		learningObjective = "Use CS concepts in a structured IB-style revision challenge.",
		difficulty = difficulty,
		commandTerm = commandTerm,
		type = "multiple_choice",
		prompt = prompt,
		options = options,
		answer = answerIndex,
		acceptedAnswers = { tostring(options[answerIndex]) },
		acceptedKeywords = {},
		markscheme = { explanation },
		explanation = explanation,
		commonMistake = commonMistake,
		tags = tags,
		xp = xp,
		damage = damage,
		masteryImpact = masteryImpact,
		sourceNote = "Original IB Realms seed question; not copied from past papers or paid question banks.",
	})
end

local function text(id, topicId, difficulty, commandTerm, prompt, keywords, markscheme, explanation, commonMistake, tags, xp, damage, masteryImpact)
	table.insert(Q, {
		id = id,
		subjectBase = "computer_science",
		subjectIds = { "cs_hl", "cs_sl" },
		topicId = topicId,
		subtopic = tags[1],
		learningObjective = "Explain or apply CS concepts with cause-and-effect reasoning.",
		difficulty = difficulty,
		commandTerm = commandTerm,
		type = "text",
		prompt = prompt,
		options = {},
		answer = table.concat(keywords, ", "),
		acceptedAnswers = {},
		acceptedKeywords = keywords,
		markscheme = markscheme,
		explanation = explanation,
		commonMistake = commonMistake,
		tags = tags,
		xp = xp,
		damage = damage,
		masteryImpact = masteryImpact,
		sourceNote = "Original IB Realms seed question; not copied from past papers or paid question banks.",
	})
end

mcq("cs_hw_l1_cpu", "cs_hardware", 1, "state", "Which component performs arithmetic and logic operations inside the CPU?", { "RAM", "ALU", "ROM", "Secondary storage" }, 2, "The ALU carries out arithmetic and logical comparisons as part of CPU processing.", "A common mistake is choosing RAM because it is close to the CPU, but RAM stores working data rather than performing operations.", { "alu", "cpu", "recognition" }, 10, 25, { alu = 2 })
mcq("cs_hw_l1_rom", "cs_hardware", 1, "identify", "Which memory usually stores firmware or boot instructions that should remain when power is off?", { "Cache", "RAM", "ROM", "Register" }, 3, "ROM is non-volatile and is commonly used for firmware needed during startup.", "RAM is volatile, so its contents are lost when power is removed.", { "rom", "memory", "recognition" }, 10, 25, { memory = 2 })
mcq("cs_hw_l2_cache", "cs_hardware", 2, "explain", "Why can cache memory improve CPU performance?", { "It permanently stores every file", "It keeps frequently used data close to the CPU", "It replaces all secondary storage", "It increases screen resolution" }, 2, "Cache is very fast memory near or on the CPU, so repeated instructions or data can be accessed with less delay.", "Cache does not permanently store files; it reduces access time for selected working data.", { "cache", "performance", "understanding" }, 15, 30, { cache = 3 })
mcq("cs_hw_l2_bus", "cs_hardware", 2, "describe", "What is the role of buses in a computer system?", { "They transport data, addresses, or control signals between components", "They cool the CPU", "They convert binary into images", "They store the operating system permanently" }, 1, "Buses are communication pathways connecting components such as the CPU, memory, and devices.", "Do not confuse buses with storage; they move signals rather than store data long-term.", { "buses", "cpu", "understanding" }, 15, 30, { buses = 3 })
mcq("cs_hw_l3_video_editor", "cs_hardware", 3, "apply", "A video editor slows down when previewing effects, while normal document work is fine. Which upgrade is most likely to help the visual processing workload?", { "A stronger GPU", "A smaller monitor", "Less RAM", "A slower secondary drive" }, 1, "A GPU is designed for parallel graphics and visual processing, so it can reduce a visual effects bottleneck.", "A faster CPU may help some tasks, but the scenario points specifically to graphics effects.", { "gpu", "bottleneck", "application" }, 20, 35, { performance = 4 })
mcq("cs_hw_l3_database", "cs_hardware", 3, "apply", "A database server keeps pausing because active queries exceed available working memory. Which bottleneck is most directly indicated?", { "ROM capacity", "RAM capacity", "Speaker output", "Screen refresh rate" }, 2, "Active queries need working memory. If the server runs out of RAM, it may swap to slower storage and pause.", "ROM is not used as active working memory for live database queries.", { "ram", "bottleneck", "application" }, 20, 35, { ram = 4 })
text("cs_hw_l4_fetch_execute", "cs_hardware", 4, "explain", "Explain how the control unit and ALU work together during a simple fetch-execute cycle.", { "control", "alu", "instruction" }, { "Control unit fetches/decodes or coordinates the instruction", "ALU performs arithmetic or logic if required", "Data and signals move between CPU registers/memory using buses" }, "A strong answer links coordination to execution: the control unit directs the operation while the ALU performs arithmetic or logical work when the instruction requires it.", "Weak answers list CPU parts without saying how they interact.", { "fetch_execute", "alu", "control_unit", "analysis" }, 35, 45, { fetchExecute = 6 })
text("cs_hw_l5_boss_upgrade", "cs_hardware", 5, "evaluate", "A simulation is slow because it repeatedly processes large numeric calculations, but disk loading is already fast. Evaluate whether upgrading secondary storage or CPU/cache is the better first upgrade.", { "cpu", "cache", "secondary", "bottleneck" }, { "Identifies processing/cache as the likely bottleneck", "Explains why faster storage may not help much once loading is not the issue", "Acknowledges limitations such as RAM, GPU, or software design" }, "The best upgrade targets the actual bottleneck. If repeated calculations are slow and disk loading is already fast, CPU performance and cache may matter more than secondary storage speed, though other constraints should be checked.", "The common error is assuming any faster part improves all tasks equally.", { "boss", "performance", "bottleneck", "synthesis" }, 55, 60, { performance = 8, evaluation = 4 })

mcq("cs_data_l1_bit", "cs_data", 1, "state", "What is a bit?", { "A complete image file", "A binary digit, 0 or 1", "A character set", "A compression algorithm" }, 2, "A bit is one binary digit and can hold the value 0 or 1.", "A byte is usually eight bits; do not confuse the two units.", { "binary", "recognition" }, 10, 25, { binary = 2 })
mcq("cs_data_l2_binary_place", "cs_data", 2, "calculate", "What is binary 1011 in denary?", { "7", "9", "11", "13" }, 3, "1011₂ = 8 + 0 + 2 + 1 = 11.", "The leftmost 1 in a four-bit number represents 8, not 1.", { "binary", "conversion", "understanding" }, 15, 30, { binary = 3 })
mcq("cs_data_l3_image", "cs_data", 3, "apply", "An image uses more bits per pixel. What is the most direct effect?", { "More possible colours and usually larger file size", "Lower resolution only", "No storage change", "Sound quality improves" }, 1, "Higher colour depth allows more colour values per pixel and increases the raw data needed.", "Resolution and colour depth are different; both affect file size but in different ways.", { "image", "bit_depth", "application" }, 20, 35, { images = 4 })
text("cs_data_l5_logic", "cs_data", 5, "evaluate", "A sensor alarm should trigger only when motion is detected and the system is armed, except when maintenance mode is on. Describe a suitable Boolean logic structure.", { "and", "not", "maintenance" }, { "Uses AND for motion and armed", "Uses NOT maintenance as an additional condition", "Expresses final idea such as motion AND armed AND NOT maintenance" }, "The alarm condition can be represented as Motion AND Armed AND NOT Maintenance. This combines a required pair of true inputs with an exception.", "A common mistake is using OR, which would trigger the alarm when only one condition is true.", { "boss", "boolean", "logic_gates", "synthesis" }, 55, 60, { logic = 8 })

mcq("cs_alg_l1_selection", "cs_algorithms", 1, "identify", "Which programming structure chooses between different paths based on a condition?", { "Sequence", "Selection", "Iteration", "Decomposition" }, 2, "Selection uses conditions such as IF statements to choose a path.", "Iteration repeats instructions; it does not primarily choose between alternatives.", { "selection", "recognition" }, 10, 25, { algorithms = 2 })
mcq("cs_alg_l2_loop", "cs_algorithms", 2, "explain", "Why is a loop useful when validating user input?", { "It can repeatedly ask until the input meets a condition", "It removes all variables", "It permanently stores data", "It changes binary to hex" }, 1, "A validation loop repeats the prompt while input is invalid, reducing acceptance of bad data.", "Validation checks suitability; verification checks accurate copying.", { "iteration", "validation", "understanding" }, 15, 30, { validation = 3 })
mcq("cs_alg_l3_search", "cs_algorithms", 3, "apply", "A sorted list of 10,000 IDs must be searched many times. Which search is usually more efficient?", { "Linear search", "Binary search", "Random guessing", "Bubble sort" }, 2, "Binary search repeatedly halves a sorted search space, so it is usually much faster for large sorted lists.", "Binary search requires sorted data; without that condition, linear search may be needed.", { "searching", "application" }, 20, 35, { searching = 4 })
text("cs_alg_l5_trace", "cs_algorithms", 5, "analyse", "A loop meant to count from 1 to 10 starts at 1 but never changes the counter. Explain the fault and the correction.", { "counter", "increment", "loop" }, { "Identifies missing counter update", "Explains infinite loop risk", "Adds increment or update inside the loop" }, "The condition may remain true forever if the counter is never updated. Incrementing the counter inside the loop allows it to eventually stop.", "A weak answer only says 'the loop is wrong' without identifying state change.", { "boss", "debugging", "iteration", "synthesis" }, 55, 60, { debugging = 8 })

mcq("cs_db_l1_primary", "cs_databases", 1, "identify", "What is the purpose of a primary key?", { "To uniquely identify each record", "To make text bold", "To delete all duplicate tables", "To draw a chart" }, 1, "A primary key uniquely identifies a record in a table.", "A field can store data without being unique; the primary key must uniquely identify records.", { "primary_key", "recognition" }, 10, 25, { databases = 2 })
mcq("cs_db_l3_foreign", "cs_databases", 3, "apply", "A school database has Students and Classes tables. Which field would likely connect a student record to a class record?", { "A foreign key such as ClassID in Students", "A random paragraph field", "A duplicated full class table inside every student", "A print button" }, 1, "A foreign key stores a value that links to a primary key in another table, supporting relationships without excessive duplication.", "Duplicating whole tables creates redundancy and update problems.", { "foreign_key", "relationships", "application" }, 20, 35, { relationships = 4 })
text("cs_db_l5_design", "cs_databases", 5, "evaluate", "A library tracks books and loans. Explain why separate Book, Member, and Loan tables may be better than one huge table.", { "redundancy", "primary", "foreign" }, { "Reduces repeated book/member data", "Allows keys to link loans to books and members", "Improves integrity and easier updates" }, "Separate related tables reduce redundancy and allow each loan to reference a book and member using keys. This makes updates safer and queries clearer.", "One-table designs often repeat the same book or member data many times.", { "boss", "normalisation", "relationships", "synthesis" }, 55, 60, { databases = 8 })

mcq("cs_oop_l1_class", "cs_oop", 1, "state", "In OOP, what is a class?", { "A blueprint for creating objects", "A single value only", "A database record", "A network cable" }, 1, "A class defines the attributes and methods that objects created from it can have.", "An object is an instance made from the class; the class is the blueprint.", { "classes", "recognition" }, 10, 25, { oop = 2 })
mcq("cs_oop_l3_inherit", "cs_oop", 3, "apply", "A game has Enemy as a general class and FlyingEnemy as a specialised type. Which OOP idea is most relevant?", { "Inheritance", "Compression", "Binary search", "Foreign key" }, 1, "Inheritance lets a specialised class reuse or extend behaviour from a more general class.", "Composition can also model relationships, but the scenario describes a specialised type of enemy.", { "inheritance", "application" }, 20, 35, { inheritance = 4 })
text("cs_oop_l5_structure", "cs_oop", 5, "evaluate", "For a quiz battle game, justify one attribute and one method a Question class should contain.", { "attribute", "method", "question" }, { "Names a suitable attribute such as prompt, difficulty, topic, or answer", "Names a suitable method such as checkAnswer or awardFeedback", "Justifies how these support object responsibilities" }, "A good design gives the Question object data it owns, such as prompt and accepted answers, plus behaviour like checking an answer or returning feedback.", "Avoid listing random variables without linking them to the object's responsibility.", { "boss", "class_design", "synthesis" }, 55, 60, { oop = 8 })

return Q
