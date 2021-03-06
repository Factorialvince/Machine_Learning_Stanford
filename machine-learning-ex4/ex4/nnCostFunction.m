function [J grad] = nnCostFunction(nn_params, ...
                                   input_layer_size, ...
                                   hidden_layer_size, ...
                                   num_labels, ...
                                   X, y, lambda)
%NNCOSTFUNCTION Implements the neural network cost function for a two layer
%neural network which performs classification
%   [J grad] = NNCOSTFUNCTON(nn_params, hidden_layer_size, num_labels, ...
%   X, y, lambda) computes the cost and gradient of the neural network. The
%   parameters for the neural network are "unrolled" into the vector
%   nn_params and need to be converted back into the weight matrices. 
% 
%   The returned parameter grad should be a "unrolled" vector of the
%   partial derivatives of the neural network.
%

% Reshape nn_params back into the parameters Theta1 and Theta2, the weight matrices
% for our 2 layer neural network
Theta1 = reshape(nn_params(1:hidden_layer_size * (input_layer_size + 1)), ...
                 hidden_layer_size, (input_layer_size + 1));

Theta2 = reshape(nn_params((1 + (hidden_layer_size * (input_layer_size + 1))):end), ...
                 num_labels, (hidden_layer_size + 1));

% Setup some useful variables
m = size(X, 1);
         
% You need to return the following variables correctly 
J = 0;
Theta1_grad = zeros(size(Theta1));
Theta2_grad = zeros(size(Theta2));

% ====================== YOUR CODE HERE ======================
% Instructions: You should complete the code by working through the
%               following parts.
%
% Part 1: Feedforward the neural network and return the cost in the
%         variable J. After implementing Part 1, you can verify that your
%         cost function computation is correct by verifying the cost
%         computed in ex4.m
%
% Part 2: Implement the backpropagation algorithm to compute the gradients
%         Theta1_grad and Theta2_grad. You should return the partial derivatives of
%         the cost function with respect to Theta1 and Theta2 in Theta1_grad and
%         Theta2_grad, respectively. After implementing Part 2, you can check
%         that your implementation is correct by running checkNNGradients
%
%         Note: The vector y passed into the function is a vector of labels
%               containing values from 1..K. You need to map this vector into a 
%               binary vector of 1's and 0's to be used with the neural network
%               cost function.
%
%         Hint: We recommend implementing backpropagation using a for-loop
%               over the training examples if you are implementing it for the 
%               first time.
%
% Part 3: Implement regularization with the cost function and gradients.
%
%         Hint: You can implement this around the code for
%               backpropagation. That is, you can compute the gradients for
%               the regularization separately and then add them to Theta1_grad
%               and Theta2_grad from Part 2.
%

% Add ones to the X data matrix
X = [ones(m, 1) X];

z2 = Theta1 * X';
a2 = sigmoid(z2);

y2 = a2';
y2 = [ones(m, 1) y2];

z3 = Theta2 * y2';
a3 = sigmoid(z3);
h = a3';

h_Vec = h';
h_Vec = h_Vec(:);

for i = 1:m
    for j = 1:num_labels
             ybnr(i,j) = (y(i) == j);
    endfor
endfor

y_Vec = ybnr';
y_Vec = y_Vec(:);
             
J = J - 1 / m * (y_Vec' * log(h_Vec) + (1 - y_Vec)' * log(1 - h_Vec)) ...
- lambda / (2 * m) * sum(Theta1(:,1) .* Theta1(:,1)) ...
+ lambda / (2 * m) * sum(sum(Theta1 .* Theta1)) ...
- lambda / (2 * m) * sum(Theta2(:,1) .* Theta2(:,1)) ...
+ lambda / (2 * m) * sum(sum(Theta2 .* Theta2));

%a1 = [ones(1, m); a1];
%z1 = [ones(1, m); z1];

a2 = [ones(1, m); a2];
z2 = [ones(1, m); z2];

for t = 1:m
    a_Vec = h(t,:);
    delta3 = (a_Vec - ybnr(t,:))';
    %size(Theta2' * delta3)
    %size(z2(:,t))
    delta2 = Theta2' * delta3 .* sigmoidGradient(z2(:,t));
    
    a2_Vec = a2'(t,:);
    DD2 = delta3 * a2_Vec;
    size(DD2);
    size(Theta2);
          Theta2_grad = Theta2_grad + DD2;
          
    a1_Vec = X(t,:);
    DD1 = delta2(2:end) * a1_Vec;
    size(DD1);
    size(Theta1);
          Theta1_grad = Theta1_grad + DD1;
endfor
          
          Theta2_grad = Theta2_grad / m + lambda / m * Theta2;
          Theta2_grad(:,1) = Theta2_grad(:,1) - lambda / m * Theta2(:,1);
          Theta1_grad = Theta1_grad / m + lambda / m * Theta1;
          Theta1_grad(:,1) = Theta1_grad(:,1) - lambda / m * Theta1(:,1);

          

% -------------------------------------------------------------

% =========================================================================

% Unroll gradients
grad = [Theta1_grad(:) ; Theta2_grad(:)];


end
