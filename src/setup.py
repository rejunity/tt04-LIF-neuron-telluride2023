input_number = 32;
neurons_0 = 4;
neurons_1 = 4;
neurons_2 = 4;

f = open('connections_0.mem', 'w')
for i in range(input_number):
    for j in range(neurons_0):
        f.write('1')
    f.write('\n')

f = open('connections_1.mem', 'w')
for i in range(neurons_0):
    for j in range(neurons_1):
        f.write('1')
    f.write('\n')

f = open('connections_2.mem', 'w')
for i in range(neurons_1):
    for j in range(neurons_2):
        f.write('1')
    f.write('\n')
