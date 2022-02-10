function [ref_new,sample_new] = SynchronizeArray(ref,sample, w)

[d, ig, ib] = dtw(ref,sample,  w*1000 );
ref_new = zeros(1, length(ig));
sample_new = zeros(1, length(ig));

for i=1:length(ig)
    index_g = ig(i);
    index_s = ib(i);
   ref_new(i) = ref(index_g);
   sample_new(i) = sample(index_s);
end

%cut to max length of ref (assymetric DTW)

end

