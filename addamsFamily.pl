parent(grandmama,pancho).
parent(grandmama,gomez).
parent(hester,morticia).
parent(hester,ophelia).
parent(unknown,hester).
parent(unknown,fester).
parent(gomez,pugsley).
parent(gomez,wednesday).
parent(morticia,pugsley).
parent(morticia,wednesday).

% Grandparent Rule %

grandparent(Grandparent, Grandchild) :-
  parent(Grandparent, Parent),
  parent(Parent, Grandchild).

auntOrUncle(X, Y) :-
  parent(p, Y),
  sibling(X, p).

ancestor(X, Y) :-
  parent(X, Y).
  
ancestor(X, Y) :-
  ancestor(X, P), parent(P, Y).
