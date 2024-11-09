import networkx as nx
import matplotlib.pyplot as plt

# Define the manager relationships
relationships = [
    ("alice", "bob"), ("alice", "carla"), ("alice", "dave"),
    ("alice", "elsa"), ("alice", "frank"), ("bob", "george"),
    ("bob", "harry"), ("bob", "inez"), ("bob", "juan"),
    ("bob", "kevin"), ("george", "keeley"), ("inez", "leon"),
    ("leon", "manuel"), ("juan", "nancy"), ("nancy", "ophelia"),
    ("ophelia", "parker"), ("kevin", "quincey"), ("quincey", "ray"),
    ("dave", "stephen"), ("dave", "tracy"), ("tracy", "violet"),
    ("stephen", "whitney"), ("stephen", "xavier"), ("whitney", "angelica"),
    ("violet", "zeke"), ("violet", "betty"), ("violet", "candace"),
    ("violet", "donna"), ("elsa", "eddie"), ("eddie", "francine"),
    ("eddie", "ginny"), ("eddie", "hans"), ("ginny", "iris"),
    ("hans", "jack")
]

# Create a directed graph
G = nx.DiGraph()

# Add edges to the graph
G.add_edges_from(relationships)

# Use graphviz_layout for a hierarchical structure
pos = nx.nx_agraph.graphviz_layout(G, prog="dot")

# Draw the hierarchical tree
plt.figure(figsize=(15, 10))
nx.draw(G, pos, with_labels=True, node_size=3000, node_color="lightblue", font_size=10, font_weight="bold", arrows=False)
plt.title("Company Hierarchy Tree")
# plt.show()
plt.savefig('company-tree.png')
