import random
import sys

random.seed(int(sys.argv[1]))
LIM = 10**18
print(random.randint(-LIM, LIM), random.randint(-LIM, LIM))
