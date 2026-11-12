// Format: "Title|Description|Difficulty(1-3)|Minutes"
const Map<String, List<String>> seedRoadmap = {
  'Engineering Mathematics': [
    'Linear Algebra|Matrices, determinants, rank, eigenvalues and eigenvectors.|2|90',
    'Calculus|Limits, continuity, differentiation, maxima/minima, integration.|2|90',
    'Probability|Conditional probability, Bayes theorem, distributions.|3|100',
    'Statistics|Mean, variance, standard distributions, hypothesis basics.|2|80',
  ],
  'Discrete Mathematics': [
    'Propositional Logic|Connectives, equivalences, normal forms, inference.|1|60',
    'Sets, Relations, Functions|Equivalence relations, partial orders, lattices.|2|80',
    'Graph Theory|Connectivity, coloring, matching, planarity, trees.|3|100',
    'Combinatorics|Counting, permutations, recurrence relations, pigeonhole.|3|100',
  ],
  'Digital Logic': [
    'Boolean Algebra|Laws, K-maps, minimization, canonical forms.|1|60',
    'Combinational Circuits|Adders, multiplexers, decoders, encoders.|2|70',
    'Sequential Circuits|Flip-flops, counters, registers, state machines.|2|80',
    'Number Systems|Binary, signed numbers, floating point, codes.|1|50',
  ],
  'Computer Organization and Architecture': [
    'Machine Instructions|Addressing modes, instruction formats, ALU.|2|70',
    'Pipelining|Hazards, stalls, speedup, forwarding.|3|90',
    'Cache and Memory|Cache mapping, hit ratio, virtual memory.|3|90',
    'I/O Interfaces|Interrupts, DMA, polling.|2|60',
  ],
  'Programming and Data Structures': [
    'C Programming Basics|Pointers, recursion, storage classes, arrays.|2|80',
    'Linked Lists, Stacks, Queues|Implementation and applications.|2|80',
    'Trees and BST|Traversals, AVL, heaps, B-trees.|3|100',
    'Hashing|Hash functions, collisions, open addressing.|2|60',
  ],
  'Algorithms': [
    'Asymptotic Analysis|Big-O, recurrences, master theorem.|2|70',
    'Sorting and Searching|Quick, merge, heap sort, binary search.|2|80',
    'Greedy and Dynamic Programming|Knapsack, LCS, matrix chain, Huffman.|3|120',
    'Graph Algorithms|BFS, DFS, shortest paths, MST.|3|110',
  ],
  'Theory of Computation': [
    'Finite Automata and Regular Languages|DFA, NFA, regex, pumping lemma.|2|90',
    'Context-Free Languages|CFG, PDA, closure properties.|3|90',
    'Turing Machines|Decidability, halting problem.|3|90',
    'Complexity Classes|P, NP, NP-complete, reductions.|3|80',
  ],
  'Compiler Design': [
    'Lexical Analysis|Tokens, lexemes, finite automata for scanners.|1|50',
    'Parsing|LL(1), LR(0), SLR, CLR, LALR parsers.|3|110',
    'Syntax-Directed Translation|Attributes, SDT schemes, intermediate code.|2|70',
    'Code Optimization|Basic blocks, DAG, data flow analysis.|2|70',
  ],
  'Operating Systems': [
    'Processes and Threads|PCB, context switching, CPU scheduling.|2|80',
    'Synchronization|Semaphores, monitors, deadlocks.|3|100',
    'Memory Management|Paging, segmentation, page replacement.|3|90',
    'File Systems and Disk|Allocation methods, disk scheduling.|2|70',
  ],
  'Databases': [
    'ER Model and Relational Model|Keys, ER to tables, relational algebra.|1|70',
    'SQL|Queries, joins, aggregation, nested queries.|2|80',
    'Normalization|Functional dependencies, 3NF, BCNF.|3|90',
    'Transactions and Indexing|ACID, serializability, B+ trees.|3|100',
  ],
  'Computer Networks': [
    'Network Models|OSI and TCP/IP layers, switching.|1|60',
    'Data Link Layer|Framing, error detection, sliding window, MAC.|3|100',
    'Network Layer|IP addressing, subnetting, routing algorithms.|3|100',
    'Transport and Application Layer|TCP, UDP, congestion control, DNS, HTTP.|2|80',
  ],
  'General Aptitude': [
    'Verbal Ability|Grammar, vocabulary, reading comprehension.|1|50',
    'Quantitative Aptitude|Percentages, ratios, time and work.|2|70',
    'Logical Reasoning|Series, puzzles, arrangements.|2|60',
    'Data Interpretation|Charts, tables, graphs.|2|60',
  ],
};
