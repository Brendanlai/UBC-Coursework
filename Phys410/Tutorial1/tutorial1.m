% 2 Arrays and array operations
v1 = 1:10
v2 = linspace(10,1,10)

% Generates an error -> dif array dimensions
%result = v1*v2

% Transpose
result1 = v1* v2'

result2 = v2' * v1

% element-wise multiplication
v1 .* v2

% defining matrices
A = [[1, -1, 0];[0,1,-1];[-1,0,1]]
B = [[0,-1,1];[-1,1,1];[1,0,-1]]

% matrix multiplication
prod1 = A*B
% elementwise multiplication
prod2 = A.*B

% 2.1 Right and left division, solution of linear systems

% right division -> a/b = a/b
% left divison -> a\b = b/a

% linear system -> Ax = b, a = A^-1b -> x = A\b

A = [[-7, 3, -12];[10, -6,2];[1,-9,-22]]
b = [33; -10; 0]
x = A\b

% ones, zeros, eye
a = zeros(3)
b = eye(3)
c = ones(3)

M = [[eye(3) ones(3)];[eye(3) zeros(3)]]

% spin matrices 
sig1 = [[0 1]; [1 0]]
sig2 = [[0 -i]; [i 0]]
sig3 = [[1 0]; [0 -1]]

% should all equal to the identity matrix
sig1^2
sig2^2
sig3^2

% siga*sigb + sigb*siga = 2kdelta*I -> [[0 0]; [0 0]] if a\=b and [[2 0]; [0 2]]
sig1*sig2 + sig2*sig1
sig1*sig1 + sig1*sig1

% 5 defining a simple function
max3(1, 1, 3)

% Testing max3
for a = 1:3
    for b = 1:3
        for c = 1:3
            [a,b,c];
            max3(a,b,c);
            if max3(a,b,c) == max([a,b,c])
                fprintf('yup \n')
            else
                fprintf('nope \n')
            end
        end
    end
end

% gets the maximum of 3 values without using matlab functions
function val = max3(a, b, c)
    if a == b & a == c
        val = a;
    elseif a == b & a ~=c
        if a > c
            val = a;
        else
            val = c;
        end
    elseif a == c & a ~= b
        if a > b
            val = a;
        else
            val = b;
        end
    else
        if a > b & a > c
            val = a;
        elseif b > c
            val = b;
        else 
            val = c;
        end
    end
          
end


