a=[[1,2],[1,2],[1,2],[1,4],[1,2,3],[1,2],[1,2]]
b=[a[x] for x in range(len(a)) if not(a[x] in a[:x])]
print(b)
