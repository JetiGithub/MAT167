% Google Page Rank Using Moler's Code 

% creation of adjaceny matrix (by rows) going A, B, C.. L row wise and
% columnwise
A = [0 1 0 0 1 0 0 0 0 0 0 0; 
0 0 1 0 0 1 0 0 0 0 0 0; 
0 0 0 1 0 1 0 0 0 0 0 0; 
0 0 0 0 0 0 1 1 0 0 0 0;
0 1 0 0 0 1 0 0 0 1 0 0;
0 0 0 0 1 0 1 0 0 0 0 0; 
0 0 1 1 0 1 0 1 0 0 1 1; 
0 0 0 0 0 0 0 0 0 0 0 0;
1 0 0 0 1 0 0 0 0 0 0 0; 
0 0 0 0 1 1 0 0 1 0 0 1;
0 0 0 0 0 1 0 0 0 1 0 0; 
0 0 0 0 0 0 0 1 0 0 1 0; 
]; 
G = A'; % transpose matrix so columns indicate outgoing links from nodes
n = 12; % number of nodes ie A to L
c = sum(G,1);% count of outgoing links for each node
   k = find(c~=0); % Find indices of nodes with outgoing links 
   % (non-zero columns)
   D = sparse(k,k,1./c(k),n,n); %sparse diagnal matrix for nodes having
   % outgoing links, normalizes matrix by dviding each link by total number 
   % of outgoing linkes from each node
e = ones(n,1); % vector of ones size n
I = speye(n,n); % identity matrix of size n
p = 0.85; % damping factor set at 0.85
x = (I - p*G*D)\e; % Page Rank Equation 
x = x/sum(x); %Normalizing the solution vector so that the 
% sum of all elements equals 1
x %output weight of each page

% defines page names
pageNames = {'A', 'B', 'C', 'D', 'E', 'F', 'G', 'H', 'I', 'J', 'K', 'L'};

% display the results where to the left is page and to the right is the
% page rank 
fprintf('    Page     PageRank\n');
fprintf('    _____    ________\n\n');
for i = 1:n
    fprintf('    {%2s}    %.6f\n', pageNames{i}, x(i));
end

% define the list of unique keywords (terms) and initialize query matrix
terms = {'Apples', 'Bananas', 'Broccoli', 'Cabbage', 'Kumquats', ...
         'Strawberries', 'Oranges', 'Plums', 'Coconuts', 'Blueberries', ...
         'Cherries', 'Lettuce', 'Spinach', 'Blackberries', 'Peas', ...
         'Onions', 'Corn', 'Radishes', 'Raspberries', 'Cucumbers', ...
         'Carrots', 'Black Beans', 'Mushrooms', 'Peppers', 'Celery', ...
         'Pineapples'};

% define the list of webpages (documents)
documents = {'WebPage A', 'WebPage B', 'WebPage C', 'WebPage D', 'WebPage E', ...
              'WebPage F', 'WebPage G', 'WebPage H', 'WebPage I', 'WebPage J', ...
              'WebPage K', 'WebPage L'};



% define the keywords for each webpage
webpage_keywords = {
    'WebPage A', {'Apples', 'Bananas', 'Broccoli', 'Cabbage', 'Kumquats', 'Strawberries'};
    'WebPage B', {'Oranges', 'Plums', 'Coconuts', 'Kumquats', 'Blueberries', 'Cherries', 'Strawberries'};
    'WebPage C', {'Lettuce', 'Spinach', 'Bananas', 'Blackberries', 'Peas', 'Strawberries'};
    'WebPage D', {'Oranges', 'Onions', 'Celery', 'Kumquats', 'Corn', 'Radishes'};
    'WebPage E', {'Pineapples', 'Plums', 'Corn', 'Cherries', 'Broccoli', 'Peas', 'Strawberries'};
    'WebPage F', {'Lettuce', 'Onions', 'Coconuts', 'Spinach', 'Peas', 'Strawberries'};
    'WebPage G', {'Apples', 'Onions', 'Broccoli', 'Corn', 'Cabbage', 'Peas'};
    'WebPage H', {'Plums', 'Blueberries', 'Raspberries', 'Blackberries', 'Strawberries'};
    'WebPage I', {'Apples', 'Cucumbers', 'Carrots', 'Spinach', 'Corn', 'Black Beans', 'Cabbage'};
    'WebPage J', {'Mushrooms', 'Carrots', 'Lettuce', 'Radishes', 'Peppers', 'Broccoli', 'Spinach'};
    'WebPage K', {'Carrots', 'Lettuce', 'Celery', 'Onions', 'Cabbage', 'Peas'};
    'WebPage L', {'Broccoli', 'Cabbage', 'Carrots', 'Spinach', 'Corn', 'Peas'};
};

% create a term-document matrix initialized with zeros
numTerms = length(terms);
numDocuments = length(documents);
T = zeros(numTerms, numDocuments);

% create a term map for indexing terms
termMap = containers.Map(terms, 1:numTerms);

% create the term-document matrix
for i = 1:numDocuments %loop through document (1 to toal) 
    doc = documents{i};%get current document from the document cell array
    keywords = webpage_keywords{strcmp(webpage_keywords(:,1), doc), 2};
    % finds words associated with current todcument by matching document 
    % name with first column of webpage_keywords & retrives corresponding
    % keywords in 2nd column
    for j = 1:length(keywords) %loop through each keyword for current document 
        term = keywords{j};% get current term from list of keywords 
        if isKey(termMap, term) %if key exists in term map dictionary, then get
            %index of keyword and set entry to 1 in matrix T
            termIndex = termMap(term);
            T(termIndex, i) = 1;
        end
    end
end



% define query vectors
q1 = [0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Broccoli query
q2 = [1 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Apples or Bananas query
q3 = [0 0 0 1 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Cabbage and Strawberries query
q4 = [0 0 0 0 -1 0 0 0 0 0 1 0 0 0 0 0 0 0 0 0 0 0 0 0 0 0]; % Cherries not kumquats query

% calculate query results
result1 = T' * q1'; % transpose q1 to match the dimensions
result2 = T' * q2'; % transpose q2 to match the dimensions
result3 = T' * q3'; % transpose q3 to match the dimensions
result4 = T' * q4'; % transpose q4 to match the dimensions



% display webpages based on query results
fprintf('Webpages for Broccoli:\n');
if any(result1 > 0) % if the result is greater than 0 then display webpage
    for i = 1:length(result1)
        if result1(i) > 0
            fprintf('%s\n', documents{i});
        end
    end
end

fprintf('\nWebpages for Apples or Bananas:\n');
% if the result is greater than 0 then display webpage
if any(result2 > 0)
    for i = 1:length(result2)
        if result2(i) > 0
            fprintf('%s\n', documents{i});
        end
    end
end

fprintf('\nWebpages for Cabbage and Strawberries:\n');
% if the result is greater than or equal to 2 then display webpage
if any(result3 >= 2)
    for i = 1:length(result3)
        if result3(i) >= 2
            fprintf('%s\n', documents{i});
        end
    end
end

fprintf('\nWebpages for Cherries but not Kumquats:\n');
%  if the result is equal to 1 then display webpage
if any(result4 == 1)
    for i = 1:length(result4)
        if result4(i) == 1
            fprintf('%s\n', documents{i});
        end
    end
end



