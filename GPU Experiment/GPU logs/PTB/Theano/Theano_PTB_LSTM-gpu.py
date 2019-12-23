#!/usr/bin/env python
# coding: utf-8

# In[1]:


import theano
import theano.tensor as T
import lasagne
import lasagne.layers as L
from lasagne import init
import numpy as np
import LoggerYN as YN
import time
import datetime
import sys

from data import load_ptb, load_ptb_vocab


# In[2]:


class PtbIterator:

    def __init__(self, train, batch_size, seq_len, skip_step=5):
        self.data = load_ptb(train)
        self.batch_size = batch_size
        self.seq_len = seq_len
        self.skip_step = skip_step
        self.reset()
    
    def __iter__(self):
        self.reset()
        return self
    
    def __next__(self):
        x = np.zeros((self.batch_size, self.seq_len), dtype=np.int32)
        y = np.zeros((self.batch_size, self.seq_len), dtype=np.int32)
        
        for i in range(self.batch_size):
            if self.cur_idx + self.seq_len >= len(self.data):
                raise StopIteration
            x[i, :] = self.data[self.cur_idx:self.cur_idx+self.seq_len]
            y[i, :] = self.data[self.cur_idx+1:self.cur_idx+self.seq_len+1]
            self.cur_idx += self.skip_step
            
        return x, y.ravel()
    
    def reset(self):
        self.cur_idx = 0


# In[3]:


def ptb_lstm(input_var, vocabulary_size, hidden_size, seq_len, num_layers, dropout, batch_size):
    l_input = L.InputLayer(shape=(batch_size, seq_len), input_var=input_var)
    l_embed = L.EmbeddingLayer(l_input, vocabulary_size, hidden_size,
                               W=init.Uniform(1.0))
    l_lstms = []
    for i in range(num_layers):
        l_lstm = L.LSTMLayer(l_embed if i == 0 else l_lstms[-1], hidden_size,
                             ingate=L.Gate(W_in=init.GlorotUniform(), W_hid=init.Orthogonal()),
                             forgetgate=L.Gate(W_in=init.GlorotUniform(), W_hid=init.Orthogonal(), 
                                               b=init.Constant(1.0)),
                             cell=L.Gate(W_in=init.GlorotUniform(), W_hid=init.Orthogonal(), W_cell=None, 
                                         nonlinearity=lasagne.nonlinearities.tanh), 
                             outgate=L.Gate(W_in=init.GlorotUniform(), W_hid=init.Orthogonal()))
        l_lstms.append(l_lstm)
    l_drop = L.DropoutLayer(l_lstms[-1], dropout)
    l_out = L.DenseLayer(l_drop, num_units=vocabulary_size, num_leading_axes=2)
    l_out = L.ReshapeLayer(l_out, (l_out.output_shape[0] * l_out.output_shape[1], l_out.output_shape[2]))
    l_out = L.NonlinearityLayer(l_out, nonlinearity=lasagne.nonlinearities.softmax)
    return l_out


# In[4]:


def ptb_train(model, data_iter, func, epoch, print_every=50):
    losses = []
    for i, (inputs, labels) in enumerate(data_iter):
        loss = func(inputs, labels)
        
        losses.append(loss)
        if (i + 1) % print_every == 0:
            print('[%d, %5d] train loss: %.3f' % (epoch, i + 1, np.mean(losses)))
            losses = []
        sys.stdout.flush()

            
            
def ptb_test(model, data_iter, func, epoch):
    losses = []
    t_acc=0
    count=0
    for inputs, labels in data_iter:
        loss,acc = func(inputs, labels)
        losses.append(loss)
        t_acc += acc
        count += 1
        
    loss = np.mean(losses)
    perplexity = np.exp(loss)
    print('[%d] test loss: %.3f accuracy: %.3f' % (epoch, np.mean(losses), t_acc/count))
    sys.stdout.flush()

    
    
def ptb_run(n_epochs,hidden_size, batch_size, seq_len, dropout, num_layers):
    np.random.seed(1)

    ptb_vocab = load_ptb_vocab()
    vocabulary_size = len(ptb_vocab)
    
    train_iter = PtbIterator(train=True, batch_size=batch_size, seq_len=seq_len)
    test_iter = PtbIterator(train=True, batch_size=batch_size, seq_len=seq_len)
    
    input_var = T.imatrix('inputs')
    labels_var = T.ivector('labels')
    variables = [input_var, labels_var]
    model = ptb_lstm(input_var, vocabulary_size, hidden_size, seq_len, num_layers, dropout, batch_size)
    
    preds = lasagne.layers.get_output(model)
    loss = lasagne.objectives.categorical_crossentropy(preds, labels_var).mean()
    test_acc = T.mean(T.eq(T.argmax(preds, axis=1), labels_var),
                  dtype=theano.config.floatX)
    
    params = lasagne.layers.get_all_params(model, trainable=True)
    updates = lasagne.updates.adadelta(loss, params)
    train_func = theano.function(variables, loss, updates=updates)
    test_func = theano.function(variables, [loss,test_acc])
    
    memT,cpuT,gpuT = YN.StartLogger("Theano_CPU", "PTB")   
    
    start = time.time()
    current_time = time.time()
    time_consumed=current_time-start
    epoch=1
    
    while(epoch <= n_epochs and time_consumed <= 86400 ):
        ptb_train(model, train_iter, train_func, epoch)
        ptb_test(model, test_iter, test_func, epoch)
        epoch += 1
        time_consumed=(time.time())-start
        print("Time since beginning ", str(datetime.timedelta(seconds=time_consumed)) )
        sys.stdout.flush()

            
    f = open('Theano_CPU_IMDB_LSTM_model', 'wb')
    cPickle.dump(model, f, protocol=cPickle.HIGHEST_PROTOCOL)
    f.close()
    end = time.time()
    YN.EndLogger(memT,cpuT,gpuT)
    print("\n\nTotal Time Consumed ", str(datetime.timedelta(seconds=time_consumed)))


# In[ ]:


ptb_run(n_epochs=50, hidden_size = 200, batch_size = 20, seq_len = 30, dropout = 0.5, num_layers = 2)


# In[ ]:




